#!/bin/sh
sudo intel_gpu_top -o - | awk 'NR>=3 {if(++count==2){print 100-$4; fflush(stdout); count=0}}'
