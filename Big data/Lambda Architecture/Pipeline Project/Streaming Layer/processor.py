import os
import json
import sys
from pathlib import Path
from pyflink.datastream import StreamExecutionEnvironment, CheckpointingMode
from pyflink.common import WatermarkStrategy, Time
from pyflink.datastream.connectors.kafka import KafkaSource, KafkaOffsetsInitializer
from pyflink.common.typeinfo import Types
from pyflink.datastream.window import TumblingProcessingTimeWindows
from pyflink.datastream.connectors.file_system import FileSink, OutputFileConfig, RollingPolicy
from pyflink.common.serialization import SimpleStringSchema, Encoder
from pyflink.datastream.functions import KeyedProcessFunction
from pyflink.datastream.state import ValueStateDescriptor

# --- 1. Initialize Environment ---
env = StreamExecutionEnvironment.get_execution_environment()

# Enable checkpointing (required for File Sinks to flush data)
env.enable_checkpointing(5000) 
env.get_checkpoint_config().set_checkpointing_mode(CheckpointingMode.EXACTLY_ONCE)

# Set Python path for the venv
python_path = os.path.join(os.getcwd(), "venv", "Scripts", "python.exe")
env.set_python_executable(python_path)

# Add Kafka Connector JAR
current_dir = Path(__file__).parent.resolve()
jar_path = current_dir / "flink-sql-connector-kafka-1.17.1.jar"
env.add_jars(jar_path.as_uri())
env.set_parallelism(1)

# --- 2. Define Kafka Source ---
kafka_source = KafkaSource.builder() \
    .set_bootstrap_servers("localhost:9092") \
    .set_topics("logistics_stream") \
    .set_group_id("logistics_analytics_group") \
    .set_starting_offsets(KafkaOffsetsInitializer.latest()) \
    .set_value_only_deserializer(SimpleStringSchema()) \
    .build()

stream = env.from_source(kafka_source, WatermarkStrategy.no_watermarks(), "Kafka Source")

# --- 3. Data Parsing ---
def parse_json(value):
    try:
        data = json.loads(value)
        return (str(data['Asset_ID']), int(data['Waiting_Time']), str(data['Traffic_Status']), str(data['Shipment_Status']))
    except Exception:
        return None

# The Base Stream: All valid logistics records
parsed_stream = stream.map(
    parse_json, 
    output_type=Types.TUPLE([Types.STRING(), Types.INT(), Types.STRING(), Types.STRING()])
).filter(lambda x: x is not None)

# --- 4. Requirement: 5-Minute Tumbling Window Average ---
# This calculates performance for EVERY unique asset in the stream
avg_waiting_time = parsed_stream \
    .key_by(lambda x: x[0]) \
    .window(TumblingProcessingTimeWindows.of(Time.minutes(5))) \
    .reduce(lambda x, y: (x[0], (x[1] + y[1]) // 2, x[2], x[3]))

# --- 5. Requirement: Stateful High-Traffic Alerting ---
class FinalStatefulAlert(KeyedProcessFunction):
    def __init__(self):
        self.alert_state = None

    def open(self, runtime_context):
        descriptor = ValueStateDescriptor("alert_status", Types.BOOLEAN())
        self.alert_state = runtime_context.get_state(descriptor)

    def process_element(self, *args):
        try:
            # Flexible argument handling for different worker environments
            value = args[0]
            out = args[2] if len(args) >= 3 else args[1]
            
            asset_id, waiting_time, traffic, status = value
            already_alerted = self.alert_state.value() or False

            # Condition: Heavy Traffic AND In Transit
            is_high_traffic = (traffic == 'Heavy' and status == 'In Transit')

            if is_high_traffic and not already_alerted:
                print(f"⚠️  STATEFUL ALERT: {asset_id} is in Heavy Traffic!")
                self.alert_state.update(True)
                if hasattr(out, 'collect'): out.collect(value) 
                
            elif not is_high_traffic and already_alerted:
                print(f"✅ CLEAR: {asset_id} traffic resolved.")
                self.alert_state.clear()
            
        except Exception as e:
            print(f"Logic Error: {e}")

# Apply stateful logic keyed by Asset_ID
alert_stream = parsed_stream.key_by(lambda x: x[0]).process(FinalStatefulAlert())

# --- 6. File Sink (Persistence) ---
output_path = os.path.join(os.getcwd(), "alerts_output")

file_sink = FileSink.for_row_format(
    output_path,
    Encoder.simple_string_encoder()
).with_output_file_config(
    OutputFileConfig.builder().with_part_prefix("logistics_alerts").with_part_suffix(".csv").build()
).with_rolling_policy(
    RollingPolicy.default_rolling_policy(part_size=1024, rollover_interval=5000)
).build()

# --- 7b. Averages File Sink Configuration ---
avg_output_path = os.path.join(os.getcwd(), "averages_output")

avg_file_sink = FileSink.for_row_format(
    avg_output_path,
    Encoder.simple_string_encoder()
).with_output_file_config(
    OutputFileConfig.builder()
    .with_part_prefix("logistics_averages")
    .with_part_suffix(".csv")
    .build()
).with_rolling_policy(
    RollingPolicy.default_rolling_policy(part_size=1024, rollover_interval=60000) # Roll every minute
).build()

# Connect the Averages Stream to this new Sink
def format_avg_for_csv(value):
    # value is (Asset_ID, Avg_Wait_Time, Traffic, Status)
    return f"{value[0]},{value[1]},{value[2]},{value[3]}"

avg_waiting_time.map(
    format_avg_for_csv, 
    output_type=Types.STRING()
).sink_to(avg_file_sink)

# Connect alerts to the CSV sink
def format_for_csv(value):
    return f"{value[0]},{value[1]},{value[2]},{value[3]}"

alert_stream.map(
    format_for_csv, 
    output_type=Types.STRING() 
).sink_to(file_sink)

# --- 7. Final Execution ---
avg_waiting_time.print("[5-MIN WINDOW AVG]")

print("-" * 50)
print(f"🚀 STARTING LOGISTICS PIPELINE")
print(f"📊 Averages: 5-Minute Tumbling Window")
print(f"📂 Alert Storage: {output_path}")
print("-" * 50)

env.execute("Smart Logistics Stream Processor")
