#!/bin/bash

nowtime=`date +"%Y-%m-%d__%H:%M:%S"`

d_info=`df -m | grep "^/dev/" | awk -v ntime=$nowtime 'BEGIN{num = 0; unum = 0; hnum = 0} {num += $2; unum += $3; hnum += $4;printf("%s 1 %s %sM %sM %.2f%%\n", ntime, $6, $2, $4, $3 / $2 * 100)} END{printf("%s 0 disk %dM %dM %.2f%%", ntime, num, hnum, unum / num * 100)}'`

echo "$d_info"
