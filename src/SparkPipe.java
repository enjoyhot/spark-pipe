import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

/**
 * 
 * @author enjoyhot
 * @github https://github.com/enjoyhot
 *
 */

public class SparkPipe {
	
	public static void main(String[] args) throws Exception {

		String pySplitProgram = "";
		String externProgramCmd = "";
		String mergedFile = "";
		String outputFolder = "";
	    int thread_num = 1;
	    
		/**
		 * test
		 */
//        pySplitProgram = args[0];
//        externProgramCmd = args[1];
//        mergedFile = args[2];
//        outputFolder = args[3];
        
		int optSetting = 0;  
		for (; optSetting < args.length; optSetting++) {  
			if ("-s".equals(args[optSetting])) {  
				pySplitProgram = args[++optSetting];  
			} else if ("-e".equals(args[optSetting])) {  
				externProgramCmd = args[++optSetting];  
			} else if ("-i".equals(args[optSetting])) {  
				mergedFile = args[++optSetting];  
			} else if ("-o".equals(args[optSetting])) {  
				outputFolder = args[++optSetting];  
			} else if ("-t".equals(args[optSetting])) {  
				thread_num = Integer.parseInt(args[++optSetting]);  
			}  
		} 
		
        // spark config
	    SparkConf conf = new SparkConf().setAppName("spark-pipe");
	    JavaSparkContext sc = new JavaSparkContext(conf);	    
	    
	    JavaRDD<String> mergedRDD = sc.textFile(mergedFile).repartition(thread_num);
	    System.out.println("Partitions num:" + mergedRDD.getNumPartitions());
	    
	    String splitProgramCmd = "python " + pySplitProgram;    
	    JavaRDD<String> outPutStream = mergedRDD.pipe(splitProgramCmd).pipe(externProgramCmd).cache();	    
   
	    // remove hdfs folder if exist
	    FileSystem hdfs = FileSystem.get(new Configuration());
	    Path newFolderPath = new Path(outputFolder);	    
	    if(hdfs.exists(newFolderPath)){
	       
	       hdfs.delete(newFolderPath, true);
	    }    
	    outPutStream.saveAsTextFile(outputFolder);	        	    

    	
	}
}
