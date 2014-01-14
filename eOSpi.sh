#!/bin/bash

#########################################
#					#
#   Script PostInstall elementaryOS	#
#					#
#   Version 0.1 : 09 novembre 2013	#
#   - version initiale			#
#					#
#   Version 0.2 : 13 novembre 2013	#
#   - mise à jour par Thomas Bourcey 	#
#   - correction de scripting		#
#     					#
#   By KeitIG <mail@mail.com>		#
#					#
#########################################

# DEBUG MODE #
##############
# set -x

# TODO LIST #
#############
# - Gestion des logs
# - Gestion des erreurs

# VARIABLES #
#############

# Script
SCRIPT_COM=${0##*/} # Nom du script
SCRIPT_DATE=`date +"%Y%m%d%H%M%S"`
SCRIPT_HUMAN_DATE=`date +"%d/%m/%Y - %H:%M:%S"`
SCRIPT_LOG_FOLDER="/data/tmp/log"
SCRIPT_LOG_FILE="${LOG_FOLDER}/${SCRIPT_COM}-${SCRIPT_DATE}.log"
TYPEMACHINE=""
INSTALLKERNEL="0" # Par défaut on n'installe pas de kernel

# FONCTIONS #
#############
pause(){
	echo ""
	read -p "Appuyez sur <Entrée> pour continuer ..." touche
	echo ""
}

# DEBUT DU SCRIPT #
###################

# Le script doit-être lancé en tant que root
clear
if [ $EUID -ne 0  ]; then
        echo -e "\r\e[0;31m$SCRIPT_COM doit-être lancé en tant que root !!! \e[0m"
		echo -e "\r\e[0;31mLancer le script tel que : sudo $SCRIPT_COM \e[0m"
        exit 1
fi

# Récupération du type d'architecture du PC (32 bits ou 64 bits)
if [ `getconf LONG_BIT` = "64" ]  > /dev/null 2>&1; then
    TYPEMACHINE="64"
else
    TYPEMACHINE="32"
fi

# Intro
echo "---------- Script de post-installation Elementary-OS 0.2 Luna | v0.2 par KeitIG ----------"
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
echo "	4- Installation de Bumblebee (en fonction de votre configuration hardware)"
echo "	5- Nettoyage du système"
echo "	6- Reboot"
echo ""
echo "En cas de problème, envoyez un mail à [keitig.dev@gmail.com]"
pause

echo "----- Etape 1) Mises à jour du système ------"
echo "Automatique"
echo ""

echo "----- Etape 2) Ressources tierces -----------"
echo "elementary-tweaks sera automatiquement installé"
echo ""
echo "Voulez vous installer des thèmes supplémentaires ? (Oui/Non)"
echo -n "Votre choix : "
read INSTALLTHEMES
echo "Voulez vous installer des thèmes Plank (dock) supplémentaires ? (Oui/Non)"
echo -n "Votre choix : "
read INSTALLPLANKTHEMES
echo "Voulez vous installer des packs d'icones supplémentaires ? (Oui/Non)"
echo -n "Votre choix : "
read INSTALLICONSPACKS
echo "Voulez vous installer des fonds d'écrans supplémentaires ? (Oui/Non)"
echo -n "Votre choix : "
read INSTALLWALLPAPERSPACK
echo ""

echo "----- Etape 3) Kernel -----------------------"
echo "ATTENTION - Ceci peut rendre votre système instable"
echo "Installer Kernel:"
echo "	0 - Ne pas mettre à jour le kernel"
echo "	1 - Installer le kernel 3.8.0"
echo "	2 - Installer le kernel 3.11.2"
echo "	3 - Installer le kernel 3.12.0"
echo ""
echo -n "Votre choix : "
read INSTALLKERNEL

echo "----- Etape 4) Bumblebee --------------------"
echo "Bumblebee permet de désactiver la carte graphique nVidia lorsqu'elle n'a pas besoin d'être utilisée."
echo "En savoir plus sur la technologie Optimus: http://doc.ubuntu-fr.org/nvidia_optimus"
echo ""
CHECK_BUMBLEBEE=`lspci -vnn | grep -i "\[0300\]" | wc -l`
if [ $CHECK_BUMBLEBEE -gt "1" ]  > /dev/null 2>&1; then
	echo "Vous possédez deux entrées vidéos, vous pouvez installer Bumblebee."
	echo "Voulez vous installer Bumblebee ? (Oui/Non)"
	echo -n "Votre choix : "
	read INSTALLBUMBLEBEE
else
	echo "Vous ne possédez qu'une carte graphique, il n'y à pas besoin d'installer Bumblebee"
	echo ""
fi

echo "----- Etape 5) Nettoyage --------------------"
echo "Automatique"
echo ""

echo "----- Etape 6) Redémarrage ------------------"
echo "Automatique"
echo ""

echo "Le script va se lancer, vous devriez avoir le temps de prendre un café ;)"
pause


# Etape 1
sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

# Etape 2
echo "Installation des PPA"
echo " - ppa:versable/elementary-update"
echo " - ppa:elementaryos-fr-community"
sudo add-apt-repository ppa:versable/elementary-update -y  > /dev/null 2>&1
sudo add-apt-repository ppa:elementaryos-fr-community -y > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt-get install elementary-tweaks -y

if [[ $INSTALLTHEMES =~ ^[Yy|Oo]$ || $INSTALLTHEMES == "Oui" || $INSTALLTHEMES == "oui" ]]; then
	sudo apt-get install elementary-blue-theme elementary-champagne-theme elementary-colors-theme elementary-dark-theme elementary-harvey-theme elementary-lion-theme elementary-matteblack-theme elementary-milk-theme elementary-plastico-theme -y
fi

if [[ $INSTALLPLANKTHEMES =~ ^[Yy|Oo]$ || $INSTALLPLANKTHEMES == "Oui" || $INSTALLPLANKTHEMES == "oui" ]]; then
	sudo apt-get install elementary-plank-themes -y
fi

if [[ $INSTALLICONSPACK =~ ^[Yy|Oo]$ || $INSTALLICONSPACK == "Oui" || $INSTALLICONSPACK == "oui" ]]; then
	sudo apt-get install elementary-elfaenza-icons elementary-emod-icons elementary-enumix-utouch-icons elementary-nitrux-icons elementary-taprevival-icons elementary-thirdparty-icons pacifica-icon-theme -y
fi

if [[ $INSTALLWALLPAPERSPACK =~ ^[Yy|Oo]$ || $INSTALLWALLPAPERSPACK == "Oui" || $INSTALLWALLPAPERSPACK == "oui" ]]; then
	sudo apt-get install elementary-wallpaper-collection -y
fi

# Etape 3

#echo "	1- Kernel 3.8.0"
#echo "	2- Kernel 3.11.2"
#echo "	3- Kernel 3.12.0"
#echo "	0- Ne rien faire"

if [ -d /tmp ]; then
	mkdir -p /tmp/kernel
	cd /tmp/kernel
else
	mkdir -p /tmp/kernel
	cd /tmp/kernel
fi

case $INSTALLKERNEL in
0)
	echo "Vous avez décidé de rester en kernel 3.2"
;;
1) 
	echo "Installation du Kernel 3.8"
        sudo apt-get install linux-generic-lts-raring
;;
2)
	echo "Installation du Kernel 3.11.2"
	if [ "$TYPEMACHINE" = "32" ]; then
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-headers-3.11.2-031102-generic_3.11.2-031102.201309262136_i386.deb
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-headers-3.11.2-031102_3.11.2-031102.201309262136_all.deb
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-image-3.11.2-031102-generic_3.11.2-031102.201309262136_i386.deb
		sudo dpkg -i linux-headers-3.11.2*.deb linux-image-3.11.2*.deb
                sudo update-grub
		\rm -Rf /tmp/kernel

	elif [ "$TYPEMACHINE" = "64" ]; then
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-headers-3.11.2-031102-generic_3.11.2-031102.201309262136_amd64.deb
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-headers-3.11.2-031102_3.11.2-031102.201309262136_all.deb
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.11.2-saucy/linux-image-3.11.2-031102-generic_3.11.2-031102.201309262136_amd64.deb
		sudo dpkg -i linux-headers-3.11.2*.deb linux-image-3.11.2*.deb
                sudo update-grub
		\rm -Rf /tmp/kernel
	fi
;;
3)
	echo "Installation du Kernel 3.12.0"
	if [ "$TYPEMACHINE" = "32" ]; then
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-headers-3.12.0-031200-generic_3.12.0-031200.201311031935_i386.deb
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-image-3.12.0-031200-generic_3.12.0-031200.201311031935_i386.deb
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-headers-3.12.0-031200_3.12.0-031200.201311031935_all.deb
		sudo dpkg -i linux-headers-3.12.*.deb linux-image-3.12.*.deb
		sudo update-grub
		\rm -Rf /tmp/kernel
	elif [ "$TYPEMACHINE" = "64" ]; then
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-headers-3.12.0-031200-generic_3.12.0-031200.201311031935_amd64.deb
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-image-3.12.0-031200-generic_3.12.0-031200.201311031935_amd64.deb
		wget -c http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.12-saucy/linux-headers-3.12.0-031200_3.12.0-031200.201311031935_all.deb
		sudo dpkg -i linux-headers-3.12.*.deb linux-image-3.12.*.deb
		sudo update-grub
		\rm -Rf /tmp/kernel
	fi
;;
*) 
	echo "Mauvais choix ! :)"
	echo "Choisissez 0, 1, 2 ou 3 !"
	echo "Relancez le script"
	exit 1
esac

# Etape 4
if [[ $INSTALLBUMBLEBEE =~ ^[Yy|Oo]$ || $INSTALLBUMBLEBEE == "Oui" || $INSTALLBUMBLEBEE == "oui" ]]; then
	sudo add-apt-repository ppa:bumblebee/stable -y
	sudo apt-get update > /dev/null 2>&1
	sudo apt-get install bumblebee virtualgl -y
fi

# Etape 5
sudo apt-get autoclean > /dev/null 2>&1
sudo apt-get clean > /dev/null 2>&1
sudo apt-get autoremove -y  > /dev/null 2>&1
sudo dpkg -P `dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2`  > /dev/null 2>&1

# Etape 6
cat << EOT
  _                                    _   __ 
 |_ |  _  ._ _   _  ._ _|_  _. ._     / \ (_  
 |_ | (/_ | | | (/_ | | |_ (_| | \/   \_/ __) 
          |      ._   _.         /            
          |_ |_| | | (_|                      
                                              
EOT
echo ""
echo "Script terminé, le système va redémarrer, votre pingouin est maintenant complètement fonctionnel :)"
echo "N'hésitez pas à m'écrire un merci sur le forum d'elementaryos-fr si ce script vous a été utile :)"
echo "http://www.elementaryos-fr.org/forum/topic-214-script-eospostinstall-installation-rapide-apres-installation-d-eos-page-1.html"
pause

# Reboot du PC #
################
echo ""
echo "Votre Ordinateur va redémarrer dans 10 secondes"
echo "Pour annuler le redémarrage, faites un Ctrl+C"
echo ""
sleep 10
sudo reboot
