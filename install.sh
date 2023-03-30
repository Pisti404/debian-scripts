#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


apt update && apt upgrade -y
apt install curl git -y

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

deb http://deb.debian.org/debian sid main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian sid main contrib non-free non-free-firmware

deb http://deb.debian.org/debian bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian bullseye-backports main contrib non-free
EOT

echo "Setting repository priority"
cat <<EOT >> /etc/apt/preferences.d/default
package: *
Pin: release a=sid
Pin-Priority: 100

package: *
Pin: release a=bullseye-backports
Pin-Priority: 90

package: *
Pin: release a=bullseye
Pin-Priority: 80
EOT

echo "Upgrading system"

apt update && apt upgrade -y && apt autoremove -y 


echo "Installing gnome and default software"

apt install gnome-core libreoffice gnome-tweaks firefox-esr flatpak gnome-software-plugin-flatpak git nala vlc firmware-misc-nonfree -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Configuring Network Manager"

sed -i '/managed=fasle/d' /etc/NetworkManager/NetworkManager.conf
echo "managed=true" >> /etc/NetworkManager/NetworkManager.conf


echo "Installing firmware"
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/
cp -r linux-firmware/* /usr/lib/firmware
rm -r linux-firmware

while true; do
    read -p "Do you want to install wine and lutris? " yn
    case $yn in
        [Yy]* ) dpkg --add-architecture i386; apt update; apt install wine winetricks lutris -y; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Do you want to install Steam? " yn
    case $yn in
        [Yy]* ) dpkg --add-architecture i386; apt install steam -y; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Are you running this script on a desktop? " yn
    case $yn in
        [Yy]* ) echo "Adding lqx-kernel repository"; curl 'https://liquorix.net/install-liquorix.sh' -o liquorix.sh; chmod +x liquorix.sh; ./liquorix.sh; rm liqourix.sh; break;;
        [Nn]* ) apt install tlp -y; systemct enable tlp;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [[ $(lspci -nn | egrep -i "3d|display|vga" | grep "NVIDIA") == *NVIDIA* ]]; then
  echo "Found NVIDIA device, installing driver."
  apt install nvidia-driver -y
fi

echo "Installing customizations"
git clone https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes
chmod +x install.sh
./install.sh -b -t stylish
cd ..
rm -r grub2-themes

curl https://r4.wallpaperflare.com/wallpaper/138/915/764/debian-logo-red-spiral-logo-wallpaper-e990484de1aaaddb3607f81f00f1a6ed.jpg >> /usr/share/themes/gdmwp.jpg

apt install libglib2.0-dev dconf-cli
git clone --depth=1 https://github.com/realmazharhussain/gdm-tools.git
cd gdm-tools
chmod +x install.sh
./install.sh
set-gdm-theme set -b </usr/share/themes/gdmwp.jpg>
cd ..
rm -r gdm-tools


echo "Remove unnecessary packages"
apt autoremove -y

echo "Done, please reboot your system."
