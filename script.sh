#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

EMAIL=example@domain.com
VERSION=bionic-240
G='false'


help(){
    echo "
        GitHub: https://github.com/DomiFrahem/upgrade_bbb_22_to_24.git
        ARGS:
        -D      Удаляет полность BigBlueButton
        -S      Стадия обновления

                Первая стадия:
                ./script.sh -S 1
                Удаляет полность BigBlueButton и обновляет до Ubuntu 18.04

                Вторая стадия:
                ./script.sh -S 2
                Обновляет репозитори, обновляет пакеты и перегружает систему

                Третья стадия:
                Установка BigBlueButton
                ./script.sh -s example.mydomain.com -e exmaple@domain.com -v bionic-240 -g
                -s Наименования домена
                -e Email: Default = exmaple@domain.com
                -v Версия BigBlueButton: Default = bionic-240
                -g Устанавить greenlight
        -h      Вызов этого сообщения

"

}

del_direcotry (){
    if [[ -d $1 ]]; then
        rm -rf $1
    else
        echo "Нет директории $1"
    fi
}

delete_bbb()
{
    apt purge -ymq kurento-media-server nodejs yq bigbluebutton bbb-html5 certbot nginx nginx-common nginx-core
    apt purge -ymq bbb-apps-akka bbb-apps-screenshare bbb-client bbb-freeswitch-core bbb-fsesl-akka bbb-red5 bbb-transcode-akka bbb-web bbb-record-core kms-core kms-elements mongodb-org mongodb-org-server ffmpeg redis-server openjdk-8-jre openjdk-8-jre-headless
    apt autoremove -y

    del_direcotry '/etc/bigbluebutton'
    del_direcotry '/usr/local/bigbluebutton'
    del_direcotry '/var/log/bigbluebutton'
    del_direcotry '/usr/share/bbb-web'
    del_direcotry '/usr/share/red5'
    del_direcotry '/var/lib/red5'
    del_direcotry '/opt/freeswitch'
    del_direcotry '/usr/share/etherpad-lite'
    del_direcotry '/usr/lib/node_modules'
    del_direcotry '/var/lib/mongodb'
}

step_one (){

    echo "1. update and upgrade package"
    apt update && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y

    echo "2. Stop BigBlueButton"
    bbb-conf --stop

    echo "3. Delete package BigBlueButton and directory BigBlueButton"
    delete_bbb

    echo "4. Delete old repository"
    add-apt-repository --remove ppa:rmescandon/yq -y
    add-apt-repository --remove ppa:libreoffice/ppa -y
    add-apt-repository --remove ppa:bigbluebutton/support -y
    add-apt-repository --remove ppa:certbot/certbot -y


    echo "5. Update Repository"
    rm -rf /etc/apt/sources.list.d/*
    rm -rf /var/lib/apt/lists/*
    mv -f /etc/apt/sources.list /etc/apt/sources.list.tmp
    echo "deb http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse" > /etc/apt/sources.list


    echo "6. Update and Upgrade packages"
    apt clean && apt update -y && apt upgrade -y

    echo "7. install update-manager-core"
    apt install -y update-manager-core

    echo "8. Start upgrade system"
    do-release-upgrade
}

step_two(){
    echo "1. Insert repository"

cat > /etc/apt/sources.list << HERE
# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://archive.ubuntu.com/ubuntu bionic main restricted
# deb-src http://archive.ubuntu.com/ubuntu bionic main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://archive.ubuntu.com/ubuntu bionic-updates main restricted
# deb-src http://archive.ubuntu.com/ubuntu bionic-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu bionic universe
# deb-src http://archive.ubuntu.com/ubuntu bionic universe
deb http://archive.ubuntu.com/ubuntu bionic-updates universe
# deb-src http://archive.ubuntu.com/ubuntu bionic-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://archive.ubuntu.com/ubuntu bionic multiverse
# deb-src http://archive.ubuntu.com/ubuntu bionic multiverse
deb http://archive.ubuntu.com/ubuntu bionic-updates multiverse
# deb-src http://archive.ubuntu.com/ubuntu bionic-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu bionic-backports main restricted universe multiverse
# deb-src http://archive.ubuntu.com/ubuntu bionic-backports main restricted universe multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu bionic partner
# deb-src http://archive.canonical.com/ubuntu bionic partner

deb http://archive.ubuntu.com/ubuntu bionic-security main restricted
# deb-src http://archive.ubuntu.com/ubuntu bionic-security main restricted
deb http://archive.ubuntu.com/ubuntu bionic-security universe
# deb-src http://archive.ubuntu.com/ubuntu bionic-security universe
deb http://archive.ubuntu.com/ubuntu bionic-security multiverse
# deb-src http://archive.ubuntu.com/ubuntu bionic-security multiverse
HERE

echo "2. update and upgrade package"
apt update && apt upgrade -y && apt autoremove -y

echo "3. reboot"
reboot
}

step_three(){
    if [[ ! $SERVER_NAME ]]; then
        echo "Не передано значение -s"
        help
        exit 1
    fi
    
    if [[ $G = 'true' ]]; then 
        echo "wget -qO- http://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v $VERSION -s $SERVER_NAME -e $EMAIL -g" 
        wget -qO- http://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v $VERSION -s $SERVER_NAME -e $EMAIL -g
    else
        echo "wget -qO- http://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v $VERSION -s $SERVER_NAME -e $EMAIL"
        wget -qO- http://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v $VERSION -s $SERVER_NAME -e $EMAIL
    fi
}

while getopts :DS:gv:hs:e: flag
do
    case "${flag}" in 
        s) SERVER_NAME=${OPTARG};;
        e) EMAIL=${OPTARG};;
        v) VERSION=${OPTARG};;
        D) delete_bbb;exit 0;;
        S) STEP=${OPTARG};;
        g) G='true';;
        \?) help;exit 1;;
        h) help;exit 1;;
    esac
done

if [[ $STEP ]]; then
    case $STEP in
        1) step_one;;
        2) step_two;;
        3) step_three;;
    esac
fi