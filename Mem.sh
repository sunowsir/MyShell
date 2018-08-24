#!/bin/bash

nowdate=`date +"%Y-%m-%d_%H:%M:%S"`
total=`free -m | grep "^Mem" | awk '{printf ("%s\n", $2)}'`
used=`free -m | grep "^Mem" | awk '{printf ("%s\n", $3)}'`
((surplus=$total-$used))
proportion=`echo "$used $total" | awk '{printf("%.1f%%", $1/$2*100)}'`
dynamic_proportion=`echo "$1 $proportion" | awk '{printf("%.1f%%", 0.3*$1+0.7*$2)}'`

echo "${nowdate} ${total}M ${surplus}M ${proportion} ${dynamic_proportion}"

