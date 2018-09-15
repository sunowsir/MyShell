#!/bin/bash

source_url=$1
save_path=$2

if [[ $1 == "--help" ]];then 
    echo "you need install wget and curl before use the script. "
    echo 
    echo "usage:     ./re_pic.sh [url] [path]"
    echo 
    echo "url:       Given a URL, crawl the image from that URL."
    echo 
    echo "path:      Given a path to save the doenloaded image."
    echo 
    echo "Statement: Please beware of copyright issues, everything related to image copyright issues is not related to this script."
    echo 
    exit 0
fi

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
curl ${source_url} 1> web_code 

echo '```'
echo 
echo "Start Download:" 
echo 

wait

# Get download images url.
urls=$(cat web_code | grep -Eo '<img\s*[^>]*' | sed 's/<img\s//g' | sed 's/\/$//g' | sed 's/\<\S*="//g' | grep -Eo 'http[^"]*' | sort -u)

# Download images.
for img_url in ${urls}
do
    img_name=$(basename ${img_url})
    
    if [[ $(ls -a ${save_path} | grep -w ${img_name}) == $img_name ]];then
        echo "Duplicate name, spip."
        continue
    fi
    
    echo "Downloading: [ ${img_name} ] -> [ ${save_path} ]"
    wget -P ${save_path} ${img_url} > /dev/null 2>&1

    wait
    
    echo "Download Completed."
done

echo 
echo "Completed."
echo 

rm -rf ./web_code

exit 0
