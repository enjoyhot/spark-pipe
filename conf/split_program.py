#!/usr/bin/python
import time
import os

lines = ""
SEP = "|"

def func_line4(x,y):
    return x+'\n'+y

pre_all=''
aft_all=''

while 1:
    try:
        line = raw_input()
        line_list = line.split(SEP)

        pre = line_list[0:4] 
        pre = reduce(func_line4,pre)+"\n"
        pre_all = pre_all + pre

        aft = line_list[4:8]
        aft = reduce(func_line4,aft)+"\n"
        aft_all = aft_all + aft
    except:
        break

ROOT_DIR='/tmp/spark-pipe/'
if not os.path.exists(ROOT_DIR):
    os.makedirs(ROOT_DIR)

current_time = time.time()
path_1 = ROOT_DIR+str(current_time) + "_" + str(os.getpid()) + '_1.fastq'
path_2 = ROOT_DIR+str(current_time) + "_" + str(os.getpid()) + '_2.fastq'

with open(path_1,'w') as f:    
    f.write(pre_all)

with open(path_2,'w') as f:
    f.write(aft_all)

print path_1,path_2
