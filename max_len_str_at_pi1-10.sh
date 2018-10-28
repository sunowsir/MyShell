#!/bin/bash

#	File Name:    max_len_str_at_pi1-10.sh
#	Author:       sunowsir
#	Mail:         sunowsir@protonmail.com
#	Created Time: 2018年10月14日 星期日 16时47分44秒

pi_cmd="
grep -EIHron '[a-zA-Z0-9]+' './' 2> /dev/null | awk -F ':' -v hname=\$(hostname) '
BEGIN{
    first = \$0; 
    second = \$0; 
    third = \$0;
    first_len = length(\$3); 
    second_len = length(\$3);
    third_len = length(\$3);
}
{
    now_str = \$0;
    now_len = length(\$3);
    if (now_len > first_len) {
        third = second;
        third_len = second_len;
        second = first;
        second_len = first_len;
        first = now_str; 
        first_len = now_len; 
    } else if (now_len > second_len) {
        third = second;
        third_len = second_len;
        second = now_str;
        second_len = now_len;
    } else if (now_len > third_len) {
        third = now_str;
        third_len = now_len;
    }
}
END{
    printf(\"%s:%d:%s\\n%s:%d:%s\\n%s:%d:%s\\n\", hname, first_len, first, hname, second_len, second, hname, third_len, third);
}'"


for i in `seq 1 10`; 
do 
    info="$(ssh -t pi${i} ${pi_cmd})"
    if [[ $(echo "${info}" | head -1 | cut -d ':' -f2) -gt $(echo "${first}" | cut -d ':' -f2) ]];then
        first=$(echo "${info}" | head -1)
    fi

    if [[ $(echo "${info}" | head -2 | tail -1 | cut -d ':' -f2) -gt $(echo "${second}" | cut -d ':' -f2) ]];then
        second=$(echo "${info}" | head -2 | tail -1)
    fi

    if [[ $(echo "${info}" | tail -1 | cut -d ':' -f2) -gt $(echo "${third}" | cut -d ':' -f2) ]];then
        third=$(echo "${info}" | tail -1)
    fi

done 

echo -e "${first}\n${second}\n${third}"
