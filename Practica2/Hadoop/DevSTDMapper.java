import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;


public class DevSTDMapper extends Mapper<Object, Text, Text, DoubleWritable>{

   private final static IntWritable one = new IntWritable(1);
   private Text column = new Text();

   public void map(Object key, Text value, Context context) throws IOException {

     String[] fields = value.toString().split(",");
     if(fields[0] != "f1"){
       for(int i = 0; i<fields.length; i++) {
         context.write(Integer.toString(i), Double.parseDouble(fields[i]));
       }
     }
   }
 }
