#!/bin/bash

#########################################################OTHER FUNCTIONS START

# Help information. # 
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

# Determine if the image exists, if there is a size of zero. # 
function Judge_img() {
    # ${1} : ${save_path} 
    # ${2} : ${img_name}

    # Determine if the image is duplicated. # 
    if [[ "$(ls ${1}${2} 2> /dev/null | grep -w ${2})" == "${2}" ]];then
        return 2
    # Determine if the image size is zero. # 
    elif [[ $(ls -al ${1}${2} 2> /dev/null | awk '{print $5}') -eq 0 ]];then 
        return 1
    else 
        return 0
    fi
}

# Download. # 
function Down_img() {
    # ${1} : ${save_path} 
    # ${2} : ${img_name}
    # ${3} : ${img_url}

    wget -c -nv -nc --dns-timeout=5 --read-timeout=6 --connect-timeout=15 --output-document=${1}${2} ${3} > /dev/null 2>&1
    wait
    
    # Try again, if this image download failed. # 
    try_num=5
    while [[ $((try_num--)) ]];
    do
        Judge_img ${1} ${2}
        if [[ ${?} -ne 0 ]];then 
            rm -rf ${1}${2}
            wget -c -nv -nc --dns-timeout=5 --read-timeout=6 --connect-timeout=10 --output-document=${1}${2} ${3} > /dev/null 2>&1
            wait
        else 
            break
        fi
    done

    # curl --retry 3 --connect-timeout 15 -# -o ${save_path}${img_name} ${img_url}

    wait

    Judge_img ${1} ${2}
    if [[ ${?} -ne 0 ]];then 
        return 1
    else 
        return 0
    fi
}

function Para_analysis() {
    suffix='**'
    para_num=0
    search_name='**'
    
    # Save all parameters to the array 'para[]'.  # 
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
                if [[ "x$(echo "${save_path}" | grep -Eo '\/$')" == "x" ]];then
                    save_path="${save_path}/"
                fi
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
    
}

function Get_code() {
    # ${1} : ${source_url}
    
    # Get the web page code and save in .re_pic.get.webcode. # 
    curl --connect-timeout 10 ${1} -L -o ./.re_pic.get.webcode --silent
    wait

    try_num=5
    while [[ $((try_num--)) ]];
    do
        if [[ "x$(cat ./.re_pic.get.webcode 2> /dev/null)" == "x" ]];then 
            curl --connect-timeout 10 ${1} -L -o ./.re_pic.get.webcode --silent
            wait
        else 
            break
        fi
        
    done
    wait
    
    # Print informathon of get web source code failed. # 
    if [[ "x$(cat ./.re_pic.get.webcode 2> /dev/null)" == "x" ]];then 
        return 1
    else 
        return 0
    fi
}

function Get_urls() {
    # ${1} : ${suffix}

    # Get download all images url. # 
    if [[ "x${suffix}" == "x" ]];then
        urls=$(cat ./.re_pic.get.webcode | grep -Eo '<img\s*[^>]*' | tr -s '"' '\n' | tr -s "'" "\n" | grep -Eo '(\w*:)*(\/)*(\/\S+)+' | sort -u)
    else 
        urls=$(cat ./.re_pic.get.webcode | grep -Eo '<img\s*[^>]*' | tr -s '"' '\n' | tr -s "'" "\n" | grep -Eo '(\w*:)*(\/)*(\/\S+)+' | grep "${1}" | sort -u)
    fi
    
    if [[ "x${urls}" == "x" ]];then
        return 1
    else
        return 0
    fi
}

#########################################################OTHER FUNCTIONS END

function main() {
    
    if [[ $1 == '--help' ]]; then 
        Usage
    fi
    
    suffix='**'
    para_num=0
    search_name='**'
    # Script directory.
    nowpath=$(cd $(dirname "$0") && pwd)
    cd ${nowpath}
    
    # Parameter analysis # 
    Para_analysis $@
    
    if [[ "x${source_url}" == "x" ]];then
        echo -e "\033[1;31m URL is empty."
        Usage
    else
        echo
        echo -e "\033[1;32mSource : \033[1;34m${source_url}\033[0m"

        # Get the URL protocol. # 
        source_protocol=$(echo "${source_url}" | grep -Eo 'http\w*:')
    fi
    
    if [[ "x${save_path}" == "x" ]];then 
        touch re_pic.d
        save_path="./re_pic.d"
    fi
    
    # if don't hava the file ,touch the file. # 
    if [[ ! -f ./.re_pic.get.webcode ]];then
        touch ./.re_pic.get.webcode
    fi
    
    # Get the web code.  # 
    Get_code ${source_url}
    if [[ ${?} -ne 0 ]];then
        echo -e "\033[1;31mERROR\033[0m : Failed to get page source code."
        return 0
    fi
    
    Get_urls ${suffix}
    if [[ ${?} -ne 0 ]];then
        echo -e "\033[1;31mERROR\033[0m : No images in this URL."
        return 0
    else
        total_num=0
        failed_num=0
        success_num=0
    fi
    
    for img_url in `echo "${urls}" | tr -s " " "\n"`
    do
    
        # Get the image name. # 
        img_name=$(echo "${img_url}" | grep -Eo '\S*\.\w\w\w' | xargs -I {} basename {})
    
        if [[ "x$(echo "${img_name}" | grep "${search_name}")" == "x" ]];then
            continue;
        fi
    
        # If there is no agreement in picture URL, add the agreement for hte URL's web address. # 
        if [[ "x$(echo "${img_url}" | grep -Eo 'http\S*')" == "x" ]];then
            img_url=$(echo "${img_url}" | sed 's/^\/*//g')

            # Add the user specified missing path to picture URL. # 
            if [[ "x${add_word}" != "x" ]];then
                img_url="${source_protocol}//${add_word}${img_url}"
            else 
                img_url="${source_protocol}//${img_url}"
            fi
        fi
    
        # If there is no suffix in the picture name obtained from picture URL, add the ".jpg"  suffix to the name of the picture. # 
        if [[ "x$(echo "${img_name}" | cut -d '.' -f 2)" == "x" ]];then
            img_name="${img_name}.jpg"
        fi
    
        # Skip repeating pictures. # 
        Judge_img ${save_path} ${img_name}
        if [[ ${?} -eq 0 ]];then
            echo -e "\033[1;33mWARNING\033[0m : The image \"${img_name}\" already exists"
            ((total_num++))
            ((failed_num++))
            continue
        elif [[ ${?} -eq 1 ]];then
            rm -rf ${save_path}${img_name}
        fi
        
        # Download image from ${img_url} # 
        Down_img ${save_path} ${img_name} ${img_url}
    
        if [[ ${?} -eq 0 ]];then
            ((success_num++))
            echo -e "\033[1;32m${img_url:0:30}... -> ${save_path:0:25}.../${img_name}\033[0m"
        else
            ((failed_num++))
            echo -e "\033[31;mERROR\033[0m : The image \"${path_name:(-30)}\" download failed."
        fi
    
        ((total_num++))
    done
    
    wait
    
    # Print statistics. # 
    echo -e "\033[1;32mTotal : ${total_num} \033[1;32mSuccess : ${success_num} \033[1;31mFailure : ${failed_num}\033[0m"
    
    # delete the file of save web source code, if the file in now path. # 
    if [[ -f ./.re_pic.get.webcode ]];then
        rm -rf ./.re_pic.get.webcode
    fi
    
    return 0
}

main $@ 
wait

# Print the end information. # 
echo -e "\033[1;38mDone.\033[0m"
exit 0
