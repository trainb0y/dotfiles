#!/bin/sh
sudo intel_gpu_top -o - | awk 'NR>=3 {if(++count==2){printf 100-$4; exit}}'
