#!/bin/bash

# EOS POST-INSTALL 0.4 #
########################

# DEBUG MODE #
##############
# set -x

# TODO LIST #
#############
# - Interface Graphique (Qt, GTK ?)
# - Gestion des logs
# - Gestion des erreurs
# - Supports de plus de programmes génériques

# VARIABLES #
#############

# Script
SCRIPT_COM=$0 # Nom du script
SCRIPT_DATE=`date +"%Y%m%d%H%M%S"`
SCRIPT_HUMAN_DATE=`date +"%d/%m/%Y - %H:%M:%S"`
SCRIPT_LOG_FOLDER="/data/tmp/log"
SCRIPT_LOG_FILE="${LOG_FOLDER}/${SCRIPT_COM}-${SCRIPT_DATE}.log"
typeMachine=""
INSTALLKERNEL="0" # Par défaut on n'installe pas de kernel
FINALINSTALL=""

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
if [ $EUID -ne 0 ]; then
	echo -e "\r\e[0;31m$SCRIPT_COM doit-être lancé en tant que root !!! \e[0m"
	echo -e "\r\e[0;31mLancer le script tel que : sudo $SCRIPT_COM \e[0m"
	exit 1
fi

# Fixing Permissions
chmod 755 $SCRIPT_COM

# Récupération du type d'architecture du PC (32 bits ou 64 bits)
if [ `getconf LONG_BIT` = "64" ]  > /dev/null 2>&1; then
    typeMachine="64"
else
    typeMachine="32"
fi

# Intro
clear
echo "-------------------- eOSpi 0.4 --------------------"
echo ""
echo "Ce script exéctutera les tâches suivantes:"
echo ""
echo "        1- Mise à jour du système"
echo "        2- Installation de certaines ressources via le dépot d'Elementary Update"
echo "                - elementary-tweaks"
echo "                - thèmes         (optionnel)"
echo "                - thèmes Plank   (optionnel)"
echo "                - packs d'icônes (optionnel)"
echo "                - fond d'écrans  (optionnel)"
echo "        3- Installation de navigateurs alternatifs (optionnel)"
echo "        4- Installation d'une version de Kernel plus récente (optionnel et non recommandé)"
echo "        5- Installation de Bumblebee (optionnel)"
echo "        6- Installation de Java (optionnel)"
echo "        7- Installation de TLP (optionnel)"
echo "        8- Nettoyage du système"
echo "        9- Reboot"
echo ""
echo "En cas de problème, envoyez un mail à <keitig.dev@gmail.com>"
pause

clear
echo "Pour les questions suivantes, répondez par 'o' pour oui,"
echo "ou par n'importe quelle autre lettre pour non"
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

echo "----- Etape 3) Navigateurs ------------------"
echo "Navigateurs Web alternatifs: Mozilla Firefox, Google Chrome et Chromium"
echo ""
echo "Voulez vous installer Mozilla Firefox ?"
read installFirefox
echo ""
echo "Voulez vous installer Google Chrome ?"
read installChrome
echo ""
echo "Voulez vous installer Chromium ? (version libre de Google Chrome)"
read installChromium

echo "----- Etape 4) Kernel -----------------------"
echo "ATTENTION - Ceci peut rendre votre système instable"
echo "eOS 0.2 est optimisé pour le kernel fourni par défaut, il est conseillé de n'utiliser cette optionqu'à des fins de test !"
echo "Installer Kernel:"
echo "        0- Ne rien faire"
echo "        1- Kernel 3.8.0 (raring)"
echo "        2- Kernel 3.11 (saucy)"
echo "        3- Kernel 3.12.7 (latest stable release from kernel.org"
echo "        0- Ne rien faire"
read installKernel

echo "----- Etape 5) Bumblebee --------------------"
echo "Bumblebee permet de désactiver la carte graphique nVidia lorsqu'elle n'a pas besoin d'être utilisée."
echo "En savoir plus sur la technologie Optimus: http://doc.ubuntu-fr.org/nvidia_optimus"
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

echo "----- Etape 6) Java -------------------------"
echo "Installera Java sur votre ordinateur et son plugin web"
echo ""
echo "Voulez vous installer Java ?"
read installJava

echo "----- Etape 7) TLP --------------------------"
echo "TLP est un programme permettant d'optimiser la batterie SUR LES ORDINATEURS PORTABLES UNIQUEMENT"
echo "Notez que l'économie peut varier selon le modèle de votre ordinateur"
echo ""
echo "Voulez vous installer TLP ?"
read installTLP

echo "----- Etape 8) Nettoyage --------------------"
echo "Automatique"
echo ""

echo "----- Etape 9) Redémarrage ------------------"
echo "Automatique"
pause

clear
echo "Le script va se lancer, vous deviez avoir le temps de vous faire un café ;)"
pause


#########################################################################################
# Mise en forme de FINALINSTALL
cd /tmp

FINALINSTALL="sudo apt-get install"

echo "Mise à jour..."
sudo add-apt-repository ppa:versable/elementary-update -y  > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
FINALINSTALL+=" elementary-tweaks"


# Ressources Tierces

if [ "$installThemes" = "o" ]; then
    FINALINSTALL+=" elementary-blue-theme elementary-champagne-theme elementary-colors-theme elementary-dark-theme elementary-harvey-theme elementary-lion-theme elementary-matteblack-theme elementary-milk-theme elementary-plastico-theme"
fi

if [ "$installPlankThemes" = "o" ]; then
    FINALINSTALL+=" elementary-plank-themes"
fi

if [ "$installIconsPack" = "o" ]; then
    FINALINSTALL+=" elementary-elfaenza-icons elementary-emod-icons elementary-enumix-utouch-icons elementary-nitrux-icons elementary-taprevival-icons elementary-thirdparty-icons"
fi

if [ "$installWallpapersPack" = "o" ]; then
    FINALINSTALL+=" elementary-wallpaper-collection"
fi


# Navigateurs Alternatifs

if [ "$installFirefox" = "o" ]; then
    FINALINSTALL+=" firefox"
fi
if [ "$installChromium" = "o" ]; then
    FINALINSTALL+=" chromium-browser"
fi


# Kernels Alternatifs

if [ "$installKernel" = "1" ]; then
    FINALINSTALL+=" linux-generic-lts-raring"
fi
if [ "$installKernel" = "2" ]; then
    FINALINSTALL+=" linux-generic-lts-saucy"
fi


# Bumblebee

if [ "$installBumblebee" = "o" ]; then
    sudo add-apt-repository ppa:bumblebee/stable -y  
    FINALINSTALL+=" bumblebee virtualgl"
fi


# Java

if [ "$installJava" = "o" ]; then
    FINALINSTALL+=" openjdk-7-jre icedtea-7-plugin"
fi


# TLP
if [ "$installTLP" = "o" ]; then
    sudo add-apt-repository ppa:linrunner/tlp -y
    FINALINSTALL+=" tlp tlp-rdw"
fi


#########################################################################################



#########################################################################################
# Exécution de FINALINSTALL

sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

FINALINSTALL+=" -y"
eval "$FINALINSTALL"

#########################################################################################



#########################################################################################
# External Ressources 
clear
echo "$installChrome $typeMachine"
pause
if [ "$installChrome" = "o" ]; then
    if [ "$typeMachine" = "32" ]; then
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
        sudo dpkg -i google-chrome-stable_current_i386.deb
        sudo apt-get -f install
    fi
    if [ "$typeMachine" = "64" ]; then
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo dpkg -i google-chrome-stable_current_amd64.deb
        sudo apt-get -f install
    fi
fi

if [ "$installKernel" = "3" ]; then
    if [ "$typeMachine" = "32" ]; then
        wget kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.7-trusty/linux-headers-3.12.7-031207_3.12.7-031207.201401091657_all.deb
        wget kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.7-trusty/linux-headers-3.12.7-031207-generic_3.12.7-031207.201401091657_i386.deb
        wget kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.7-trusty/linux-image-3.12.7-031207-generic_3.12.7-031207.201401091657_i386.deb
        sudo dpkg -i linux-image-3.12.7*.deb linux-headers-3.12.7*.deb
        sudo update-grub
    fi
    if [ "$typeMachine" = "64" ]; then
        wget kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.7-trusty/linux-headers-3.12.7-031207_3.12.7-031207.201401091657_all.deb
        wget kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.7-trusty/linux-headers-3.12.7-031207-generic_3.12.7-031207.201401091657_amd64.deb
        wget kernel.ubuntu.com/~kernel-ppa/mainline/v3.12.7-trusty/linux-image-3.12.7-031207-generic_3.12.7-031207.201401091657_amd64.deb
        sudo dpkg -i linux-image-3.12.7*.deb linux-headers-3.12.7*.deb
        sudo update-grub
    fi
fi

#########################################################################################



#########################################################################################
# Nettoyage

sudo apt-get autoclean > /dev/null 2>&1
sudo apt-get clean > /dev/null 2>&1
sudo apt-get autoremove -y  > /dev/null 2>&1
sudo dpkg -P `dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2`  > /dev/null 2>&1

#########################################################################################



#########################################################################################
# Finalisation

clear

cat << EOT
  _                                    _   __ 
 |_ |  _  ._ _   _  ._ _|_  _. ._     / \ (_  
 |_ | (/_ | | | (/_ | | |_ (_| | \/   \_/ __) 
          |      ._   _.         /            
          |_ |_| | | (_|                      
                                              
EOT
echo ""
echo "Script terminé, le système va redémarrer, votre pingouin est maintenant complètement fonctionnel :)"
echo "N'hésitez pas à écrire un merci sur le forum d'elementaryos-fr si ce script vous a été utile !"
echo "http://www.elementaryos-fr.org/forum/topic-214-script-eospostinstall-installation-rapide-apres-installation-d-eos-page-1.html"
echo ""
pause

# Reboot du PC #
################
echo ""
echo "Votre Ordinateur va redémarrer dans 10 secondes"
echo "Pour annuler le redémarrage, faites un Ctrl+C"
echo ""
sleep 10
sudo reboot
