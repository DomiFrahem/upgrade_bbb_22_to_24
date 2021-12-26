#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

email=for_kbsu@alexsid.ru
version=bionic-240

while getopts v:s:e: flag
do
    case "${flag}" in 
        s) server_name=${OPTARG};;
        e) email=${OPTARG};;
        v) version=${OPTARG};;
    esac
done

wget -qO- http://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v $version -s $server_name -e $email