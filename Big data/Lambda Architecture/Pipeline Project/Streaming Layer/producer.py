import csv
import json
import time
from kafka import KafkaProducer

# Configuration
KAFKA_TOPIC = 'logistics_stream'
KAFKA_BOOTSTRAP_SERVERS = 'localhost:9092'

# Initialize Producer
producer = KafkaProducer(
    bootstrap_servers=KAFKA_BOOTSTRAP_SERVERS,
    value_serializer=lambda x: json.dumps(x).encode('utf-8')
)

def stream_data(file_path):
    print(f"Starting stream to topic: {KAFKA_TOPIC}...")
    with open(file_path, 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            # Type casting
            row['Waiting_Time'] = int(row['Waiting_Time'])
            
            # Send to Kafka
            producer.send(KAFKA_TOPIC, value=row)
            print(f"Sent: {row}")
            
            # Simulate real-time delay (e.g., 2 seconds between events)
            time.sleep(2)
    
    producer.flush()
    print("Stream finished.")

if __name__ == "__main__":
    stream_data('smart_logistics_dataset.csv')
