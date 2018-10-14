#!/bin/bash

#	File Name:    max_len_str_at_pi1-10.sh
#	Author:       sunowsir
#	Mail:         sunowsir@protonmail.com
#	Created Time: 2018年10月14日 星期日 16时47分44秒

pi_cmd="
grep -EIHron '(\\S*|\\s*)\\n' './' 2> /dev/null |  awk -F ':' '{ if (\$1 !~ /(.*\\/)*(.*\\.)((jpg)|(png)|(zip)|(rar)|(7z)|(gz)(tar))/) {print \$0;} }' |  awk -F ':' 'BEGIN{first_len = length(\$3); first = \$0; second = \$0; third = \$0;}{if (length(\$3) > first_len) {third = second; second = first; first = \$0; first_len = length(\$3); } }END{printf(\" first : \\n %s \\n second : \\n %s \\n third : \\n %s \\n\", first, second, third);}'
"

for i in `seq 1 10`;
do

    echo -e "\033[1;31mpi${i} : \033[0m"
    echo -e "\033[1;32m"
    ssh -t sunowsir@pi${i} ${pi_cmd}
    echo -e "\033[0m"

done

