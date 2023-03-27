#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt update && apt upgrde -y

echo "Recreating sources list"

rm /etc/apt/sources.list
touch /etc/apt/sources.list

cat <<EOT >> /etc/apt/sources.list
deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free

deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free

deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free

deb http://deb.debian.org/debian sid main contrib non-free
deb-src http://deb.debian.org/debian sid main contrib non-free

deb http://deb.debian.org/debian bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian bullseye-backports main contrib non-free
EOT

echo "Adding pipewire upstream stable repo" 

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 25088A0359807596

echo "deb http://ppa.launchpad.net/pipewire-debian/pipewire-upstream/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list
echo "deb-src http://ppa.launchpad.net/pipewire-debian/pipewire-upstream/ubuntu $(lsb_release -cs) main" >> /etc/apt/sources.list

echo "Adding lqx-kernel repository"

mkdir tmp
cd tmp

curl 'https://liquorix.net/install-liquorix.sh' -o liquorix.sh

chmod +x liquorix.sh

./liquorix.sh

cd ..
rm -r /tmp

echo "Setting repository priority"
---------------


echo "Upgrading system"

apt update && apt upgrade -y && apt autoremove -y 


echo "Installing gnome and default software"

