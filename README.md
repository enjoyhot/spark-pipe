
# spark-pipe

Spark-pipe is a tool for [spark][1], that changes a command line program(C/C++, Java, etc.) of stand-alone version to a distributed one. Spark-pipe makes use of [pipe-API][2] to implement the  computing task by preprocessing(merging) the source data and spliting it before executing spark map job. Its process flow could be showed as follows.
![此处输入图片的描述][3]

## Building spark-pipe

 - clone the repo
 - cd to the project directory
 
 ```shell
 $ make
 ```
After compiling, there would create a build folder and get logs like this :

> The Program has been compiled.
Location    = /xxxx/spark-pipe/build/
JAVA_HOME   = /xxxx/jdk1.8.0_77
HADOOP_HOME = /usr/local/hadoop
SPARK_HOME = /usr/local/spark

## Getting Started with spark-pipe

**Step 1** :Modify these script according your program

- merge.sh
It's a executable program you change one data unit to one string line. For example :

example_1.fastq :
```
@ERR000589.36 EAS139_45:5:1:2:1002/1
AATTGTCCAAGAGATTCTCACACATGTGAAAAATGACTGGTATAGAAGATT
+
IAIIIIIIIIIII.6ID5ID=<>>II+I2A.H.I;I.<09+2&06+&+)/&
```

example_2.fastq : 
```
@ERR000589.36 EAS139_45:5:1:2:1002/2
TCTTCACCATTCTTTTATAGCAATACATAGTATTCCATCTTAGGCCTGTTC
+
3IIFHIIGFI1IIII<I5<7,=@F4332/D+13C58:/*//'?/')*:27.
```
merge.fastq
```
@ERR000589.36 EAS139_45:5:1:2:1002/1|AATTGTCCAAGAGATTCTCACACATGTGAAAAATGACTGGTATAGAAGATT|+|IAIIIIIIIIIII.6ID5ID=<>>II+I2A.H.I;I.<09+2&06+&+)/&|@ERR000589.36 EAS139_45:5:1:2:1002/2|TCTTCACCATTCTTTTATAGCAATACATAGTATTCCATCTTAGGCCTGTTC|+|3IIFHIIGFI1IIII<I5<7,=@F4332/D+13C58:/*//'?/')*:27.
```

- split_program.py
Split one line to several lines if necessary.

- extern_program.sh    
A command line program implemented using C/C++, Java, etc.


**Step 2** :Run bash script

USAGE: ./build/pipe_execute.sh SPARK_MASTER HDFS_FILE HDFS_FOLDER PARTITION_NUM

## Example

Take the [data][4] & [conf][5] of current repo for example :
```shell
$ cd data
$ ../conf/merge.sh example_1.fastq example_2.fastq merge.fastq
$ hdfs dfs -copyFromLocal merge.fastq $HDFSPATH/merge.fastq
$ cd ../bin
$ ./pipe_execute.sh $HDFSPATH/merge.fastq $HDFSPATH/OUTPUT 1
```

### NOTE

- Make sure to **DOWLOAD** the extern programe writen in :
> ${ROOT_DIR}/conf/extern_program.sh

e.g.
```shell
/xxx/bwa mem -t 16 /xxx/hg19Index/hg19.fa ${LINE}
```

 1. ${LINE} actually is like "1.fastq 2.fastq". See output format of [split_program.py][6]. 
 2. [bwa download][7] 
 3. [hg19Index download][8]

- Make sure your **conf path** and **extern_program** can be accessed by all your computer cluster nodes if using spark cluster mode.

## License
Apache 2.0


  [1]: http://spark.apache.org/
  [2]: http://spark.apache.org/docs/latest/api/java/org/apache/spark/rdd/RDD.html#pipe
  [3]: https://github.com/enjoyhot/spark-pipe/blob/master/figure.png
  [4]: https://github.com/enjoyhot/spark-pipe/tree/master/data
  [5]: https://github.com/enjoyhot/spark-pipe/tree/master/conf
  [6]: https://github.com/enjoyhot/spark-pipe/tree/master/conf/split_program.py
  [7]: https://github.com/lh3/bwa
  [8]: http://pan.baidu.com/s/1kVdk2xD