#!/bin/bash

source_curl=$1
save_path=$2

echo "source:${source_curl}"
echo "Getting web page information, please wait."

curl ${source_curl} 1> web_code 

wait
curls=$(cat web_code | grep -Eo '<img\s*[^>]*' | sed 's/<img\s//g' | sed 's/\/$//g' | sed 's/\<\S*="//g' | grep -Eo 'http[^"]*' | sort -u)

for img_curl in ${curls}
do
    img_name=$(basename ${img_curl})
    echo "Downloading: [ ${img_name} ] ==> [ ${save_path} ]"
    wget -P ${save_path} ${img_curl} > /dev/null 2>&1
    wait
    echo "Download Completed."
done

echo "Completed."

rm -rf ./web_code
exit 0
