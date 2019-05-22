import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;



public class DevSTDMapper extends Mapper<Object, Text, Text, DoubleWritable>{


   public void map(Object key, Text value, Context context) throws IOException {

     String[] fields = value.toString().split(",");

     if(fields[0] != "f1"){
       for(int i = 0; i<fields.length; i++) {
         context.write(new Text(Integer.toString(i)), new DoubleWritable(Double.parseDouble(fields[i])));
       }
     }
   }
 }
