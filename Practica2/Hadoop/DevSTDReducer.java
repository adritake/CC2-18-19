import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;



public class DevSTDReducer<Key> extends Reducer<Key,DoubleWritable, Key,DoubleWritable> {


   public void reduce(Key key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {

     int sum = 0;
     int field = Integer.parseInt(key.toString());
     int total = 0;
     DoubleWritable result = new DoubleWritable();

     for (DoubleWritable val : values) {
       sum += val.get();
       total++;
     }
     result.set(sum/total);
     context.write(key, result);
   }
 }
