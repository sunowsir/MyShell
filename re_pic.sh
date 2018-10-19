#!/bin/bash

Usage() {
    echo "You need install wget , curl and change mode before use the script. "
    echo "Install wget(Debain) : sudo apt-get install wget"
    echo "Install curl(Debain) : sudo apt-get install curl"
    echo "Change mode :          sudo chmod +x re_pic.sh"
    echo 
    echo "Usage:    ./re_pic.sh [command] [parameter]"
    echo 
    echo "    --help        Get help information."
    echo "    -u --url:     Given a URL, crawl the image from that URL, Special characters in the URL need to be ‘\\’ for escaping"
    echo 
    echo "    -p --path:    Given a path to save the doenloaded image. The default is to create the re_pic.d directory in the current directory of the script to save the pictures."
    echo 
    echo "Statement: Please beware of copyright issues, everything related to image copyright issues is not related to this script."
    echo "    -s --suffix    According to the download link of the picture to determine the type of picture, use this parameter to filter the type of picture the user needs to download."

    echo "    -n --name      Determine the name of the image according to the download link of the picture, and use this parameter to screen the pictures that users need to download."
    echo "    -w --word      After the image download link protocol, add the known missing path before the path."
    exit 0
}

if [[ $1 == '--help' ]]; then 
    Usage
fi

suffix='**'
para_num=0
search_name='**'

for arg in $@;
do
    para[${para_num}]=${arg}
    ((para_num++))
done

for ((i = 0; i < para_num; i++));
do
    case ${para[${i}]} in
        "-u" | "--url" | "--URL" | "--Url")
            ((i++))
            source_url=${para[${i}]}
        ;;
        "-p"| "--path" | "--Path" | "--PATH")
            ((i++))
            save_path=${para[${i}]}
        ;;
        "-s" | "--suffix" | "--Suffix" | "--SUFFIX")
            ((i++))
            suffix=${para[${i}]}
        ;;
        "-n" | "--name" | "--Name" | "--NAME")
            ((i++))
            search_name=${para[${i}]}
        ;;
        "-w" | "--word" | "--Word" | "--WORD")
            ((i++))
            add_word=${para[${i}]}
        ;;
        *)
            Usage
        ;;
    esac
done

if [[ "x${save_path}" == "x" ]];then 
    touch re_pic.d
    save_path="./re_pic.d"
fi

# Script dirrctory.
nowpath=$(cd $(dirname "$0") && pwd)

# Get the URL protocol.
source_protocol=$(echo "${source_url}" | grep -Eo 'http\w*:')

# Jump to the directory where the script is located.
cd ${nowpath}

# if don't hava the file ,touch the file.
if [[ ! -f ./.re_pic.get.webcode ]];then
    touch ./.re_pic.get.webcode
fi

# Get the web page code and save in .re_pic.get.webcode.
curl --retry 3 --connect-timeout 15 ${source_url} -L -o ./.re_pic.get.webcode --silent

wait

# Get download all images url.
urls=$(cat ./.re_pic.get.webcode | grep -Eo '<img\s*[^>]*' | tr -s '"' '\n' | tr -s "'" "\n" | grep -Eo '(\w*:)*(\/)*(\/\S+)+' | grep "${suffix}" | sort -u)
# Download images.

img_nums=0

echo
echo -e "\033[1;33mSource : \033[1;34m${source_url}\033[0m"

# Print informathon of get web source code failed.
if [[ "x$(cat ./.re_pic.get.webcode 2> /dev/null)" == "x" ]];then 
    echo -e "\033[1;31m$(date +"%Y-%m-%d %H:%M:%S") Failed to get page source code(connection timeout within fifteen seconds).\033[0m"
fi

for img_url in `echo "${urls}" | tr -s " " "\n"`
do

    # Get the image name.
    img_name=$(echo "${img_url}" | grep -Eo '\S*\.\w\w\w' | xargs -I {} basename {})

    if [[ "x$(echo "${img_name}" | grep "${search_name}")" == "x" ]];then
        continue;
    fi

    # If there is no agreement in picture URL, add the agreement for hte URL's web address.
    if [[ "x$(echo "${img_url}" | grep -Eo 'http\S*')" == "x" ]];then
        img_url=$(echo "${img_url}" | sed 's/^\/*//g')
        # Add the user specified missing path to picture URL.
        if [[ "x${add_word}" != "x" ]];then
            img_url="${source_protocol}//${add_word}${img_url}"
        else 
            img_url="${source_protocol}//${img_url}"
        fi
    fi

    # If there is no suffix in the picture name obtained from picture URL, add the ".jpg"  suffix to the name of the picture.
    if [[ "x$(echo "${img_name}" | cut -d '.' -f 2)" == "x" ]];then
        img_name="${img_name}.jpg"
    fi

    # add color for print information.
    echo -e -n "\033[1;32m"

    if [[ "x$(echo "${save_path}" | grep -Eo '\/$')" == "x" ]];then
        save_path="${save_path}/"
    fi
    
    path_name=${save_path}${img_name}
    # Skip repeating pictures.
    if [[ $(ls ${save_path} | grep -w ${img_name}) == ${img_name} ]];then
        nowtime=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "\033[1;31m${nowtime} The file already exists : ${path_name:(-30)}\033[0m"
        continue
    fi

    # echo "url : ${img_url}"
    # echo "path : ${save_path}${img_name}"
    # Download image from ${img_url}
    wget -c -nv -nc --tries=2 --output-document=${save_path}${img_name} ${img_url} > /dev/null 2>&1

    # curl --retry 3 --connect-timeout 15 -# -o ${save_path}${img_name} ${img_url}

    wait
    echo "$(date +"%Y-%m-%d %H:%M:%S") ${img_url:0:30}... -> ...${path_name:(-30)}"
    
    echo -e -n "\033[0m"
    ((img_nums++))

done

wait

# print the end information.
echo -e "\033[1;38m$(date +"%Y-%m-%d %H:%M:%S") Done.\033[0m"

# print download total.
echo -e "\033[1;33mTotal  : \033[1;34m${img_nums}\033[0m"

# if hava the file of save web source code in now path, delete the file.
if [[ -f ./.re_pic.get.webcode ]];then
    rm -rf ./.re_pic.get.webcode
fi

exit 0


