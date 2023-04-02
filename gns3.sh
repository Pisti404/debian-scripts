#!/bin/bash

echo "Installing base packages and VirtualBox"
sudo apt update
sudo apt install -y python3-pip python3-pyqt5 python3-pyqt5.qtsvg python3-pyqt5.qtwebsockets qemu qemu-kvm qemu-utils libvirt-clients libvirt-daemon-system virtinst wireshark xtightvncviewer apt-transport-https ca-certificates curl gnupg2 software-properties-common \
git build-essential pcaputils libpcap-dev libelf-dev cmake \
virtualbox virtualbox-ext-pack
sudo pip3 install gns3-server --break-system-packages
sudo pip3 install gns3-gui --break-system-packages

clear
echo "Compiling ubridge from source"
git clone https://github.com/GNS3/ubridge.git
cd ubridge
make ..
sudo make install

clear
echo "Compiling dynamips from source"
git clone https://github.com/GNS3/dynamips.git
cd dynamips
mkdir build
cd build
cmake ..
sudo make install

echo "Installation is done."
