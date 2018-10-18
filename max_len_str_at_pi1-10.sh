#!/bin/bash

#	File Name:    max_len_str_at_pi1-10.sh
#	Author:       sunowsir
#	Mail:         sunowsir@protonmail.com
#	Created Time: 2018年10月14日 星期日 16时47分44秒

pi_cmd="
grep -EIHron '[a-zA-Z]+' './' 2> /dev/null | awk -F ':' '
BEGIN{
    first = \$0; 
    second = \$0; 
    third = \$0;
    first_len = length(first); 
    second_len = length(second);
    third_len = length(third);
}
{
    now_str = \$0;
    now_length = length(\$3);
    if (now_length > first_len) {
        third = second; 
        second = first; 
        first = now_str; 
        first_len = now_length; 
    } else if (now_length > second_len && now_length < first_len) {
        third = second;
        second = now_str;
        second_len = now_length;
    } else if (now_length > third_len && now_length < second_len) {
        third = now_str;
        third_len = now_length;
    }
}
END{
    printf(\" first : \\n %s \\n second : \\n %s \\n third : \\n %s \\n\", first, second, third);
}'"

for i in `seq 1 10`;
do

    echo -e "\033[1;31mpi${i} : \033[0m"
    echo -e "\033[1;32m"
    ssh -t pi${i} ${pi_cmd}
    echo -e "\033[0m"

done

