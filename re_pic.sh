#!/bin/bash

if [[ $1 == '--help' ]]; then 
    echo "you need install wget , curl and change mode before use the script. "
    echo "install wget(Debain) : sudo apt-get install wget"
    echo "install curl(Debain) : sudo apt-get install curl"
    echo "change mode : sudo chmod +x re_pic.sh"
    echo 
    echo "Usage:     ./re_pic.sh [URL] [PATH] [image type] [some word of image name]"
    echo 
    echo "    URL:       Given a URL, crawl the image from that URL, Special characters in the URL need to be ‘\\’ for escaping"
    echo 
    echo "    PATH:      Given a path to save the doenloaded image."
    echo 
    echo "Statement: Please beware of copyright issues, everything related to image copyright issues is not related to this script."
    echo 
    exit 0
fi

suffix=$3
add_word=$5
save_path=$2
source_url=$1
search_name=$4
nowpath=$(cd $(dirname "$0") && pwd)
source_protocol=$(echo "${source_url}" | grep -Eo 'http\w*:')

cd ${nowpath}

# if don't hava the file ,touch the file.
if [[ ! -f ./.re_pic.get.webcode ]];then
    touch ./.re_pic.get.webcode
fi

# Get the web page code and save in .re_pic.get.webcode.
curl --connect-timeout 5 ${source_url} -L -o ./.re_pic.get.webcode --silent

wait

if [[ "x$(cat ./.re_pic.get.webcode)" == "x" ]];then 
    echo -e "\033[1;31m$(date +"%Y-%m-%d %H:%M:%S") Failed to get page source code(connection timeout <five seconds>)."
    echo -e "\033[1;38m$(date +"%Y-%m-%d %H:%M:%S") Done.\033[0m"
    exit 1;
fi

if [[ "x"${suffix} == "x" ]];then
    suffix='**'
fi

if [[ "x"${search_name} == "x" ]];then
    search_name='**'
fi

# Get download all images url.
urls=$(cat ./.re_pic.get.webcode | grep -Eo '<img\s*[^>]*' | tr -s '"' '\n' | tr -s "'" "\n" | grep -Eo '(\w*:)*(\/)*(\/\S+)+' | grep "${suffix}"  | grep "${search_name}"  | sort -u)
# Download images.

img_nums=0

echo
echo -e "\033[1;33mSource : \033[1;34m${source_url}\033[0m"

for img_url in `echo "${urls}" | tr -s " " "\n"`
do

    img_name=$(basename ${img_url})
    
    # Skip repeating pictures.
    if [[ $(ls ${save_path} | grep -w ${img_name}) == ${img_name} ]];then
        nowtime=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "\033[1;31m${nowtime} The file already exists.\033[0m"
        continue
    fi

    if [[ "x${search_name}" != "x" && "x$(echo "${img_name}" | grep "${search_name}")" == "x" ]];then
        continue
    fi

    if [[ "x$(echo "${img_url}" | grep -Eo 'http\S*')" == "x" ]];then
        img_url=$(echo "${img_url}" | sed 's/^\/*//g')
        img_url="${source_protocol}//${add_word}${img_url}"
    fi

    # Download image from ${img_url}
    echo -e -n "\033[1;32m"
    wget -nv -l 0 -t 5 -P ${save_path} ${img_url} 
    echo -e -n "\033[0m"
    ((img_nums++))
    wait

done

wait
echo -e "\033[1;38m$(date +"%Y-%m-%d %H:%M:%S") Done.\033[0m"
echo -e "\033[1;33mTotal  : \033[1;34m${img_nums}\033[0m"

# if don hava the file, delete the file.
if [[ -f ./.re_pic.get.webcode ]];then
    rm -rf ./.re_pic.get.webcode
fi

exit 0


