#!/bin/bash


pause(){
	echo ""
	read -p "Appuyez sur <Entrée> pour continuer..." touche
	echo ""
}


if [ `getconf LONG_BIT` = "64" ]
then
    typeMachine=64
else
    typeMachine=32
fi


# Intro
clear
echo "---------- Script de post-installation Elementary-OS 0.2 Luna | v0.1 par KeitIG ----------"
echo ""
echo "Ce script exéctutera les tâches suivantes:"
echo ""
echo " 	1- Mise à jour du système"
echo "	2- Installation de certaines ressources via le dépot d'Elementary Update"
echo "		- elementary-tweaks"
echo "		- thèmes         (optionel)"
echo "		- thèmes Plank   (optionel)"
echo "		- packs d'icônes (optionel)"
echo "		- fond d'écrans  (optionel)"
echo "	3- Installation d'une version de Kernel plus récente (optionel)"
echo "	4- Installation de Bumblebee (optionel)"
echo "	5- Nettoyage du système"
echo "	6- Reboot"
echo ""
echo "En cas de problème, envoyez un mail à [keitig.dev@gmail.com]"
pause

clear
echo "Pour les questions suivantes, répondez par 'o' pour oui,"
echo "ou par n'importe quelleautre lettre pour non"
pause


echo "----- Etape 1) Mises à jour du système ------"
echo "Automatique"
echo ""

echo "----- Etape 2) Ressources tierces -----------"
echo "elementary-tweaks sera automatiquement installé"
echo ""
echo "Voulez vous installer des thèmes supplémentaires ?"
read installThemes
echo "Voulez vous installer des thèmes Plank (dock) supplémentaires ?"
read installPlankThemes
echo "Voulez vous installer des packs d'icones supplémentaires ?"
read installIconsPacks
echo "Voulez vous installer des fonds d'écrans supplémentaires ?"
read installWallpapersPack
echo ""

echo "----- Etape 3) Kernel -----------------------"
echo "ATTENTION - Ceci peut rendre votre système instable"
echo "Installer Kernel:"
echo "	0- Ne rien faire"
echo "	1- Kernel 3.8.0"
echo "	2- Kernel 3.11.2"
echo "	3- Kernel 3.12.0"
echo "	0- Ne rien faire"
read installKernel

echo "----- Etape 4) Bumblebee --------------------"
echo "Bumblebee permet de désactiver la carte graphique nVidia lorsqu'elle n'a pas besoin d'être utilisée."
echo "En savoir plus su la technologie Optimus: http://doc.ubuntu-fr.org/nvidia_optimus"
echo ""
echo "IMPORTANT - Si vous avez un PC fixe, ou si vous n'avez pas de carte graphique nVidia, veuillez sautez cette étape"
echo "          - Si vous ne savez pas:"
echo ""
lspci -vnn | grep '\''[030[02]\]'
echo ""
echo "Si deux entrées apparaissent, une Intel et une nVidia, alors vous pouvez installer Bumblebee."
echo ""
echo "Voulez vous installer Bumblebee ?"
read installBumblebee

echo "----- Etape 5) Nettoyage --------------------"
echo "Automatique"
echo ""

echo "----- Etape 6) Redémarrage ------------------"
echo "Automatique"
echo ""


clear
echo "Le script va se lancer, vous deviez avoir le temps de vous faire un café ;)"
pause


# Etape 1
sudo apt-get update
sudo apt-get dist-upgrade -y

# Etape 2
sudo apt-add-repository ppa:versable/elementary-update -y
sudo apt-get update
sudo apt-get install elementary-tweaks -y

if [ "$installThemes" = "o" ]; then
	sudo apt-get install elementary-blue-theme elementary-champagne-theme elementary-colors-theme elementary-dark-theme elementary-harvey-theme elementary-lion-theme elementary-matteblack-theme elementary-milk-theme elementary-plastico-theme -y
fi

if [ "$installPlankThemes" = "o" ]; then
	sudo apt-get install elementary-plank-themes -y
fi

if [ "$installIconsPack" = "o" ]; then
	sudo apt-get install elementary-elfaenza-icons elementary-emod-icons elementary-enumix-utouch-icons elementary-nitrux-icons elementary-taprevival-icons elementary-thirdparty-icons -y
fi

if [ "$installWallpapersPack" = "o" ]; then
	sudo apt-get install elementary-wallpaper-collection -y
fi

# Etape 3

#echo "	1- Kernel 3.8.0"
#echo "	2- Kernel 3.11.2"
#echo "	3- Kernel 3.12.0"
#echo "	0- Ne rien faire"

cd /tmp

if [ "$installKernel" = "1" ]; then
	sudo apt-get install linux-generic-lts-raring
fi

if [ "$installKernel" = "2" ]; then
	if [ "$typeMachine" = "32" ]; then
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-headers-3.11.2-031102-generic_3.11.2-031102.201309262136_i386.deb
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-headers-3.11.2-031102_3.11.2-031102.201309262136_all.deb
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-image-3.11.2-031102-generic_3.11.2-031102.201309262136_i386.deb
		sudo dpkg -i linux-headers-3.11.2*.deb linux-image-3.11.2*.deb
	elif [ "$typeMachine" = "64" ]; then
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-headers-3.11.2-031102-generic_3.11.2-031102.201309262136_amd64.deb
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-headers-3.11.2-031102_3.11.2-031102.201309262136_all.deb
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-image-3.11.2-031102-generic_3.11.2-031102.201309262136_amd64.deb
		sudo dpkg -i linux-headers-3.11.2*.deb linux-image-3.11.2*.deb
	fi
fi

if [ "$installKernel" = "3" ]; then
	if [ "$typeMachine" = "32" ]; then
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-headers-3.12.0-031200-generic_3.12.0-031200.201311031935_i386.deb
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-image-3.12.0-031200-generic_3.12.0-031200.201311031935_i386.deb
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-headers-3.12.0-031200_3.12.0-031200.201311031935_all.deb
		sudo dpkg -i linux-headers-3.12.*.deb linux-image-3.12.*.deb
		sudo update-grub
	elif [ "$typeMachine" = "64" ]; then
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-headers-3.12.0-031200-generic_3.12.0-031200.201311031935_amd64.deb
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-image-3.12.0-031200-generic_3.12.0-031200.201311031935_amd64.deb
		wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-headers-3.12.0-031200_3.12.0-031200.201311031935_all.deb
		sudo dpkg -i linux-headers-3.12.*.deb linux-image-3.12.*.deb
		sudo update-grub
	fi
fi

# Etape 4
if [ "$installBumblebee" = "o" ]; then
	sudo apt-add-repository ppa:bumblebee/stable -y
	sudo apt-get update
	sudo apt-get install bumblebee virtualgl -y
fi

# Etape 5
sudo apt-get autoclean
sudo apt-get clean
sudo apt-get autoremove -y
sudo dpkg -P `dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2`

# Etape 6
clear
echo "Script terminé, le système va redémarrer"
echo "N'hésitez pas à m'écrire un merci sur le forum d'elementaryos-fr si ce script vous a été utile :)"
pause

sudo reboot
