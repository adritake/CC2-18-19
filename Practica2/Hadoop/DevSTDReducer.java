import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;


public class DevSTDReducer<Key> extends Reducer<Key,DoubleWritable, Key,DoubleWritable> {


   public void reduce(Key key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {

     int sum = 0;
     int field = Integer.parseInt(key);
     int total = 0;

     for (DoubleWritable val : values) {
       sum += val.get();
       total++;
     }
     result.set(sum/total);
     context.write(key, result);
   }
 }
