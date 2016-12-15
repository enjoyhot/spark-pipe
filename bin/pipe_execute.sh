#!/bin/bash

if [ $# != 4 ] ; then 
echo "USAGE: $0 SPARK_MASTER HDFS_FILE HDFS_FOLDER PARTITION_NUM" 
echo " e.g.: $0 local[*] /user/xxx/merge.fastq /user/xxx/Output 4 " 
exit 1; 
fi 

ROOT_DIR=`pwd`/..

# jar path
SPARK_APP=${ROOT_DIR}/build/SparkPipe.jar

# split file program and the command line program 
SPLIT_PROGRAM=${ROOT_DIR}/conf/split_program.py
EXTERN_PROGRAM=${ROOT_DIR}/conf/extern_program.sh

# HDFS DIR EXAMPLE
# MERGED_FILE="/user/gujw/data/bwa/multi/16_merge_trans.fastq"
# OUTPUT_DIR="/user/gujw/data/bwa/Output_ERR000589"
MERGED_FILE=${2}
OUTPUT_DIR=${3}

echo "Reading File from "${MERGED_FILE}
echo "Generating output file to "${OUTPUT_DIR}
echo "Start to submit spark app..."

################### USER CONFIG ###################
# You can modify spark-submit command by yourself #
###################################################
spark-submit --class SparkPipe --master ${1} --executor-cores 1 --total-executor-cores 18 --executor-memory 4G  ${SPARK_APP} -s ${SPLIT_PROGRAM} -e ${EXTERN_PROGRAM} -i ${MERGED_FILE} -o ${OUTPUT_DIR} -t ${4}

