#!/bin/bash
start=$(date "+%s")
input1=$1
input2=$2
output=$3

paste -d "|"  - - - - < $input1 > file1
paste -d "|"  - - - - < $input2 > file2

now=$(date "+%s")
time=$((now-start))
echo "phase1 time used:$time seconds"

paste -d "|" file1 file2 > $output

rm file1
rm file2

now=$(date "+%s")
time=$((now-start))
echo "phase2 time used:$time seconds"
