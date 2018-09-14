#!/bin/bash

# Search malicious processes and save it PID.
all_Mali_ps_pid=$(ps -aux | awk '
{
    if ($3 > 50) { 
        printf("%s|", $2); 
    } 
}
')

all_Mali_ps_pid=${all_Mali_ps_pid%*|}

# if don't have malicious processe, exit.
if [[ "x"$all_Mali_ps_pid == "x" ]];then
    exit 0;
fi

# sleep five second.
sleep 5

# Check the CPU usage of those processes found 5 seconds ago.
all_Mali_ps_pid=$(ps -aux | awk -v all_Mali_ps_pid=${all_Mali_ps_pid} -v nowtime=`date +"%Y-%m-%d__%H:%M:%S"` ' 
{
    if ($2 ~ all_Mali_ps_pid && $3 > 50) {
        printf("%s %s %s %s %s %s\n", nowtime, $11, $2, $1, $3, $4);
    }
}
')

echo "$all_Mali_ps_pid"
