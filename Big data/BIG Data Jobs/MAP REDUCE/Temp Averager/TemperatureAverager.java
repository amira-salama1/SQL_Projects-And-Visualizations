import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class TemperatureAverager {

    // --- 1. MAPPER CLASS ---
    /**
     * Input: (LongWritable key, Text value) - LongWritable is the line number, Text is the line content.
     * Output: (Text key, DoubleWritable value) - City Name, Temperature (in Celsius).
     */
    public static class MapperClass extends Mapper<Object, Text, Text, DoubleWritable> {

        // Define Writable objects once for reuse
        private Text cityKey = new Text();
        private DoubleWritable temperatureValue = new DoubleWritable();

        /**
         * Converts Fahrenheit (F) to Celsius (C).
         * C = (F - 32) * 5/9
         */
        private double fahrenheitToCelsius(double fahrenheit) {
            return (fahrenheit - 32.0) * (5.0 / 9.0);
        }

        @Override
        protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            String line = value.toString();
            // Your input format is: City,Temperature(F),Population,Region,Country, ...
            String[] tokens = line.split(",");

            if (tokens.length >= 2) {
                try {
                    // tokens[0] is the City Name
                    String city = tokens[0].trim();
                    // tokens[1] is the Temperature in Fahrenheit
                    double fahrenheit = Double.parseDouble(tokens[1].trim());

                    // Convert to Celsius before emitting
                    double celsius = fahrenheitToCelsius(fahrenheit);

                    cityKey.set(city);
                    temperatureValue.set(celsius);

                    // Emit: (City Name, Temperature Value in Celsius)
                    context.write(cityKey, temperatureValue);

                } catch (NumberFormatException e) {
                    // Handle case where temperature field is not a valid number
                    System.err.println("Skipping line due to invalid temperature: " + line);
                }
            } else {
                // Handle case where line is malformed (e.g., just a header or empty)
                System.err.println("Skipping malformed line: " + line);
            }
        }
    }


    // --- 2. REDUCER CLASS ---
    /**
     * Input: (Text key, Iterable<DoubleWritable> values) - City Name, List of Temperatures (in Celsius).
     * Output: (Text key, DoubleWritable value) - City Name, Average Temperature (in Celsius).
     * Note: The reducer logic for averaging remains the same as it operates on numeric values.
     */
    public static class ReducerClass extends Reducer<Text, DoubleWritable, Text, DoubleWritable> {

        private DoubleWritable result = new DoubleWritable();

        @Override
        protected void reduce(Text key, Iterable<DoubleWritable> values, Context context) throws IOException, InterruptedException {
            double sum = 0;
            long count = 0;

            // Iterate over all temperatures (now in Celsius) for this city
            for (DoubleWritable val : values) {
                sum += val.get();
                count++;
            }

            if (count > 0) {
                double average = sum / count;
                double roundedAverage = Math.round(average * 100.0) / 100.0;
                result.set(roundedAverage);

                // Emit: (City Name, Average Temperature in Celsius)
                context.write(key, result);
            }
        }
    }


    // --- 3. DRIVER (MAIN) CLASS ---
    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println("Usage: TemperatureAverager <input-file> <output-dir>");
            System.exit(-1);
        }

        Configuration conf = new Configuration();
        // Updated job name to reflect Celsius calculation
        Job job = Job.getInstance(conf, "Average Temperature Calculation (Celsius)");

        // 1. Set the main class for the JAR
        job.setJarByClass(TemperatureAverager.class);

        // 2. Set Mapper and Reducer classes
        job.setMapperClass(MapperClass.class);
        job.setReducerClass(ReducerClass.class);

        // 3. Define the key/value types for the Mapper output
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(DoubleWritable.class);

        // 4. Define the key/value types for the final job output
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(DoubleWritable.class);

        // 5. Define input and output paths
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        // 6. Execute the job and wait for completion (Exit with job status)
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
