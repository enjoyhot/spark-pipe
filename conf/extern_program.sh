#!/bin/bash

while read LINE; do
    # write down your command line programe here.  
    /xxx/bwa mem -t 16 /xxx/hg19Index/hg19.fa ${LINE}
done

