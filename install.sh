#!/bin/bash

KOREN=$PWD

sudo apt update 

sudo apt upgrade

sudo apt install -y software-properties-common

sudo dpkg --add-architecture i386

wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -

sudo apt-add-repository https://dl.winehq.org/wine-builds/debian/

sudo apt update

sudo apt install -y winehq-stable

cd ~

wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

chmod +x winetricks

WINEPREFIX=~/.wine_n1mm WINEARCH=win32 winecfg

WINEPREFIX=~/.wine_n1mm ~/winetricks dotnet40

WINEPREFIX=~/.wine_n1mm wine $KOREN/N1MM*FullInstaller*.exe

WINEPREFIX=~/.wine_n1mm wine $KOREN/N1MM*Update*.exe

cp $KOREN/n1mm.sh ~/n1mm.sh

chmod +x ~/n1mm.sh
