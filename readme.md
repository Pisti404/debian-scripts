# Forked installer script for Debian
Steps:
- Install Debian bullseye with the non-free firmware image
- Add your user to the sudo group  (usermod -aG sudo *username*)
- Install git (apt install git)
- Clone this repo (git clone https://github.com/pisti404/debian-scripts)
- Enter into the folder, give the scripts executable permits, and run them as root (cd debian-scripts, chmod +x install.sh, ./install.sh)

Improvements:
- Fixed typos
- Replaced exit with break, when you have to choose
- Added the option for dual-boot
- Added packages:
	- **qgnomeplatform-qt5** - Makes XWayland windows "blend in" with the rest of the programs
	- **libreoffice-gnome** - Adds GTK3 theme to LibreOffice, so it wouldn't look like it's straight out of Windows 98
	- **adwaita-qt/6** - Adwaita theme for programs made with the Qt framework
	- **celluloid** - Media player based on mpv
	- **sudo** - Because Debian does not include sudo by default
	- **webext-ublock-origin-firefox** - Adds [ublock Origin](https://github.com/gorhill/uBlock) to Firefox by default
	- **protontricks** - Same functionality as winetricks, but to Steam
- Replaced packages:
	- **firefox** - replaces Firefox ESR
	- **steam-installer** - replaces the original steam package

Extra script(s):
- **gns3.sh** - Installs GNS3, a networking emulation software. Taken from [Computing for Geeks](https://computingforgeeks.com/how-to-install-gns3-on-debian/) with modifications.
