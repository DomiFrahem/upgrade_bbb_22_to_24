#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "1. update and upgrade package"
apt update && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y

echo "2. Stop BigBlueButton"
bbb-conf --stop

echo "3. Delete package BigBlueButton"
apt purge -yq kurento-media-server nodejs yq bigbluebutton bbb-html5 certbot nginx nginx-common nginx-core
apt purge -yq bbb-apps-akka bbb-apps-screenshare bbb-client bbb-freeswitch-core bbb-fsesl-akka bbb-red5 bbb-transcode-akka bbb-web bbb-record-core kms-core kms-elements mongodb-org mongodb-org-server ffmpeg redis-server openjdk-8-jre openjdk-8-jre-headless
apt autoremove -y

echo "4. Delete old repository"
add-apt-repository --remove ppa:rmescandon/yq -y
add-apt-repository --remove ppa:libreoffice/ppa -y
add-apt-repository --remove ppa:bigbluebutton/support -y
add-apt-repository --remove ppa:certbot/certbot -y

echo "5. Delete old directory BigBlueButton"

if [ -d '/etc/bigbluebutton']; then
    rm -rf /etc/bigbluebutton
fi
if [ -d '/usr/local/bigbluebutton']; then
    rm -rf /usr/local/bigbluebutton
fi
if [ -d '/var/log/bigbluebutton']; then
    rm -rf /var/log/bigbluebutton
fi
if [ -d '/usr/share/bbb-web']; then
    rm -rf /usr/share/bbb-web
fi

if [ -d '/usr/share/red5']; then
    rm -rf /usr/share/red5
fi

if [ -d '/var/lib/red5']; then
    rm -rf /var/lib/red5
fi

if [ -d '/opt/freeswitch']; then
    rm -rf /opt/freeswitch
fi

if [ -d '/usr/share/etherpad-lite']; then
    rm -rf /usr/share/etherpad-lite
fi

if [ -d '/usr/lib/node_modules']; then
    rm -rf /usr/lib/node_modules
fi

if [ -d '/var/lib/mongodb']; then
    rm -rf /var/lib/mongodb
fi

echo "6. Update Repository"
rm -rf /etc/apt/sources.list.d/*
rm -rf /var/lib/apt/lists/*
mv -f /etc/apt/sources.list /etc/apt/sources.list.tmp
echo "deb http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse" > /etc/apt/sources.list


echo "7. Update and Upgrade packages"
apt clean && apt update -y && apt upgrade -y

echo "8. install update-manager-core"
apt install -y update-manager-core

echo "9. Start upgrade system"
do-release-upgrade