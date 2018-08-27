#!/bin/bash

nowdate=`date +"%Y-%m-%d_%H:%M:%S"`

mem_info=`free -m | grep "^Mem" | awk -v last_per=$1 '{printf("%sM %sM %.1f%% %.1f%%", $2, $7, $3 / $2 * 100, 0.3 * last_per + 0.7 * ($3 / $2 * 100));}'`

echo "$nowdate $mem_info"
