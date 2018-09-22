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

echo "> source:${source_url}"
echo "> Getting information."
echo
echo '```'

# if don't hava the file ,touch the file.
if [[ ! -f web_code ]];then
    touch web_code
fi

# Get the web page code and save in web_code.
curl --connect-timeout <${5}>  ${source_url} 1> ./web_code 

echo '```'
echo 
echo "Start Download:" 
echo 

wait

if [[ "x"${suffix} == "x" ]];then
    suffix='**'
fi

if [[ "x"${search_name} == "x" ]];then
    search_name='**'
fi

# Get download images url.
urls=$(cat ./web_code | grep -Eo '<img\s*[^>]*' | tr -s '"' '\n' | grep -Eo '((/\S*)+\.(\w\w\w))|(^http\S+)|(^\/\/)' | sed 's/http://g' | sed 's/^https://g' | sed 's/^\/\///g' | grep "${suffix}$"  | grep "${search_name}"  | sort -u)

# Download images.
for img_url in `echo "${urls}" | tr -s " " "\n"`
do

    img_url=$(echo "${img_url}" | sed 's/\<https//g')
    img_url=$(echo "${img_url}" | sed 's/\<http//g')
    if [[ $(echo "${img_url}" | grep "^:") ]];
    then
        img_url=$(echo "${img_url}" | sed 's/://g')
    fi

    img_url=$(echo "${img_url}" | sed 's/\/\/\<//g')

    if [[ "x"$(echo "${source_url}" | grep "bing") != "x" ]];then

        img_url="cn.bing.com/${img_url}"
    fi

    if [[ "x"$(echo "${img_url}" | grep "^https:") == "x" ]];then
        img_url="https://${img_url}"
    fi

    img_name=$(basename ${img_url})
    
    if [[ $(ls -a ${save_path} | grep -w ${img_name}) == $img_name ]];then
        echo "Duplicate name, spip."
        echo 
        continue
    fi
    wget -P ${save_path} ${img_url} 1> /dev/null

    wait
    echo

done

echo 
echo "Completed."
echo 

# rm -rf ./web_code

exit 0


