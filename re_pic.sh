#!/bin/bash

if [[ $1 == '--help' ]]; then 
    echo "you need install wget and curl before use the script. "
    echo 
    echo "usage:     ./re_pic.sh [url] [path]"
    echo 
    echo "    url:       Given a URL, crawl the image from that URL, Special characters in the URL need to be ‘\\’ for escaping"
    echo 
    echo "    path:      Given a path to save the doenloaded image."
    echo 
    echo "Statement: Please beware of copyright issues, everything related to image copyright issues is not related to this script."
    echo 
    exit 0
fi

source_url=$1
save_path=$2
suffix=$3
search_name=$4


nowpath=$(cd $(dirname "$0") && pwd)

cd ${nowpath}

echo -e "\033[1;32msource:${source_url}\033[0m"
echo

# if don't hava the file ,touch the file.
if [[ ! -f web_code ]];then
    touch web_code
fi

# Get the web page code and save in web_code.
curl ${source_url} 1> ./web_code 2> /dev/null

wait

if [[ "x"${suffix} == "x" ]];then
    suffix='**'
fi

if [[ "x"${search_name} == "x" ]];then
    search_name='**'
fi

# Get download all images url.
urls=$(cat ./web_code | grep -Eo '<img\s*[^>]*' | tr -s '"' '\n' | tr -s "'" "\n" | grep -Eo '(\w*:)*(\/)*(\/\S*)+' | grep "${suffix}$"  | grep "${search_name}"  | sort -u)
# Download images.

for img_url in `echo "${urls}" | tr -s " " "\n"`
do

    img_name=$(basename ${img_url})
    
    # Skip repeating pictures.
    if [[ $(ls -a ${save_path} | grep -w ${img_name}) == $img_name ]];
    then
        echo -e "\033[1;31mDuplicate name, spip.\033[0m"
        continue
    fi
    
    # Download image from ${img_url}
    wget -c -nv -l 0 -t 5 -P ${save_path} ${img_url} 

    wait

done

echo
echo "Completed."
echo

# rm -rf ./web_code

exit 0


