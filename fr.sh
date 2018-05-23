################################################################
##                       French Version.                      ##
################################################################

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

{ if
(whiptail --title "RPiUpdate" --yes-button "Non" --no-button "Oui" --yesno "Mettre à jour le système (Vivement recommandé) ?" 10 80)
then
echo "${YELLOW}>>>$CURRENTUSER n' a pas activé RPiUpdate${RESET}\n" | sudo tee --append /etc/startpi/log.txt
else
echo -e "${YELLOW}>>> $CURRENTUSER a activé RPiUpdate${RESET}\n" | sudo tee --append /etc/startpi/log.txt

echo -e "${GREEN}>>> Mise à jour du système...${RESET}\n"

sudo apt-get install -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade

echo "${GREEN}>>> Mise à jour effectuée !${RESET}\n"


fi }

{ if
(whiptail --title "ChangeName" --yes-button "Non" --no-button "Oui" --yesno "Changer le nom de l' utilisateur pi (recommandé pour plus de sécurité) - Il faut être connecté avec l' utilisateur root (commande : su) ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé ChangeName" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé ChangeName" | sudo tee --append /etc/startpi/log.txt

echo "Changement du nom..."

NEW_PINAME=$(whiptail --inputbox "Entrez le nouveau nom d' utilisateur" 10 80 "pi" 3>&1 1>&2 2>&3)
sudo usermod --login $NEW_PINAME  --home /home/$NEW_PINAME --move-home pi
echo "Changement effectué !"


fi }

{ if
(whiptail --title "ChangeSSHport" --yes-button "Non" --no-button "Oui" --yesno "Changer le port ssh (Recommandé pour plus de sécurité) ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé ChangeSSHport" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé ChangeSSHport" | sudo tee --append /etc/startpi/log.txt

echo "Mise à jour du système..."

SSH_PORT=$(whiptail --inputbox "Entrez le nouveau port (choisir entre 1024 et 65535) " 10 80 "22" 3>&1 1>&2 2>&3)
    { if (("$SSH_PORT" > 220 && "$SSH_PORT" < 65535))
    then
    cp /etc/ssh/sshd_config /etc/startpi/backups/
    sed -i "s/^Port .*/Port "$SSH_PORT"/g" /etc/ssh/sshd_config
    echo "Mise à jour effectuée !"
    else
    echo "$SSH_PORT"
    echo "Erreur : Port incorrect"
    fi }

fi }

{ if
(whiptail --title "SSHSecurity" --yes-button "Non" --no-button "Oui" --yesno "Appliquer des améliorations de sécurité SSH ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé SSHSecurity" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé SSHSecurity" | sudo tee --append /etc/startpi/log.txt

echo "Chargement..."

SSH_TRY=$(whiptail --inputbox "Combien de tentatives de connexion autoriser ? " 10 80 "2" 3>&1 1>&2 2>&3)

sed -i "$ a MaxAuthTries "$SSH_TRY"" /etc/ssh/sshd_config

SSH_USERS=$(whiptail --inputbox "Quels utilisateurs autorisés ? [Un seul uniquement] " 10 80 "pi" 3>&1 1>&2 2>&3)

sed -i "$ a AllowUsers "$SSH_USERS"" /etc/ssh/sshd_config

sed -i "$ a LoginGraceTime 1m" /etc/ssh/sshd_config


echo "SSH Sécurisé !"

fi }


{ if
(whiptail --title "ChangeHostName" --yes-button "Non" --no-button "Oui" --yesno "Changer le nom de la raspberry ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé ChangeHostName" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé ChangeHostName" | sudo tee --append /etc/startpi/log.txt

echo "Changement..."

OLD_HOST=`cat /etc/hostname | tr -d " \t\n\r"`
NEW_HOST=$(whiptail --inputbox "Entrez un hostname (le nouveau nom)" 10 80 "$OLD_HOSTNAME" 3>&1 1>&2 2>&3)
sudo cp /etc/hosts /etc/startpi/backups/host/
sudo cp /etc/hostname /etc/startpi/backups/host/
sudo echo "NEW_HOST=$NEW_HOST"
sudo echo "$NEW_HOST" > /etc/hostname
sudo sed -i "s/127.0.1.1.*$OLD_HOST/127.0.1.1\t$NEW_HOST/g" /etc/hosts

echo "Changement effectué !"

fi }

echo "Programme terminé. Merci d' avoir utilisé StartPi par @zonguin !"



{ if
(whiptail --title "NodeUpdate" --yes-button "Non" --no-button "Oui" --yesno "Mettre à jour nodejs (Recommandé pour de nombreux bots) ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé NodeUpdate" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé NodeUpdate" | sudo tee --append /etc/startpi/log.txt

echo "Mise à jour de nodejs..."

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install nodejs


echo "Mise à jour effectuée !"


fi }

{ if
(whiptail --title "Ruby" --yes-button "Non" --no-button "Oui" --yesno "Installer Ruby (Recommandé pour de nombreux bots) ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé Ruby" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé Ruby" | sudo tee --append /etc/startpi/log.txt

echo "Installation..."

apt-get install dirmngr
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable -s stable --autolibs=3 --ruby --rails
sudo /usr/sbin/usermod -a -G rvm $USER
sudo chown root.rvm /etc/profile.d/rvm.sh
source /usr/local/rvm/scripts/rvm


echo "Installation effectuée !"


fi }

{ if
(whiptail --title "OtherUpdates" --yes-button "Non" --no-button "Oui" --yesno "Mettre à jour / installer d' autres frameworks (Utiles pour les installateurs suivants) ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé OtherUpdates" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé OtherUpdates" | sudo tee --append /etc/startpi/log.txt

echo "Mise à jour..."


mkdir  /tmp/startpi
cd /tmp/startpi
sudo apt-get update
wget https://cpan.metacpan.org/authors/id/A/AN/ANDK/CPAN-2.16.tar.gz
tar zxf CPAN-2.16.tar.gz
cd CPAN-2.16
perl Makefile.PL
make test
sudo make install
sudo apt-get install yarn
npm install -g steem discord.js moment bufferutil erlpack node-opus opusscript  sodium libsodium-wrappers uws mathjs convnetjs
sudo apt-get -y install git
apt-get install dirmngr

echo "Mise à jour effectuée !"

rm -rf /tmp/startpi


fi }

{ if
(whiptail --title "DelGraphic" --yes-button "Non" --no-button "Oui" --yesno "Supprimer certains paquets inutiles [Version raspbian Lite uniquement / sans interface graphique] ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé DelGraphic" | sudo tee --append /etc/startpi/log.txt
apt-get -y autoremove
else
echo "$CURRENTUSER a activé DelGraphic" | sudo tee --append /etc/startpi/log.txt

echo "Nettoyage en cours..."

apt-get -y remove --purge xserver-common x11-common gnome-icon-theme gnome-themes-standard penguinspuzzle
apt-get -y remove --purge desktop-base desktop-file-utils hicolor-icon-theme raspberrypi-artwork omxplayer
apt-get -y autoremove

echo "nettoyage effectué !"


fi }

whiptail --msgbox "Let's change pihole password" 10 80 1

{ if
(whiptail --title "usbmount" --yes-button "Non" --no-button "Oui" --yesno "Installer usbmount pour monter/démonter automatiquement les périphériques USB au branchement ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé usbmount" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé usbmount" | sudo tee --append /etc/startpi/log.txt

echo "Installation..."

apt-get install usbmount

echo "Installation effectuée !"


fi }

whiptail --msgbox "Vous allez entrer dans la partie [Installation d' utilitaires] " 10 80 1

{ if
(whiptail --title "pihole" --yes-button "Non" --no-button "Oui" --yesno "Installer pihole - Un serveur dns pour bloquer les publicités ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé pihole" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé pihole" | sudo tee --append /etc/startpi/log.txt

echo "Installation..."

curl -sSL https://install.pi-hole.net | bash

echo "Installation effectuée !"

whiptail --msgbox "Accédez à l' interfaçe pi-hole sur http://ip-de-votre-rpi/admin  " 10 80 1

    { if
    (whiptail --title "piholedns" --yes-button "Non" --no-button "Oui" --yesno "Installer Pi-hole comme un serveur DNS (ne redirigera pas les requêtes vers un DNS public - Meilleure vie privée) ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé piholedns" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé piholedns" | sudo tee --append /etc/startpi/log.txt

    echo "Installation..."

    sudo apt install unbound
    wget https://www.internic.net/domain/named.root -O /var/lib/unbound/root.hints
    sudo service unbound start
    echo "Installation effectuée !"
    whiptail --msgbox "Vous devriez aller sur https://docs.pi-hole.net/guides/unbound/ pour vous renseigner davantage  " 10 80 1


    fi }

{ if
    (whiptail --title "piholedns" --yes-button "Non" --no-button "Oui" --yesno "Changer le mot de passe de pi-hole pour plus de sécurité ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé piholedns" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé piholedns" | sudo tee --append /etc/startpi/log.txt

    echo "Chargement..."

    NEW_PASS=$(whiptail --inputbox "Entrez le mot de passe" 10 80 "" 3>&1 1>&2 2>&3)
pihole -a -p $NEW_PASS
    echo "Fait !"


    fi }

fi }


{ if
(whiptail --title "pyload" --yes-button "Non" --no-button "Oui" --yesno "Installer pyload - Un serveur de téléchargement ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé pyload" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé pyload" | sudo tee --append /etc/startpi/log.txt

echo "Installation..."

sudo apt-get install python-support python-crypto python-pycurl tesseract-ocr tesseract-ocr-eng python-imaging python-pip python-dev pyopenssl rhino -y
sudo apt-get install libmozjs-24-bin
cd /usr/bin
ln -s js24 js
cp /etc/apt/sources.list /etc/startpi/backups/sources.list
sed -i "$ a deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi" /etc/apt/sources.list
sed -i "$ a deb http://mirrordirector.raspbian.org/raspbian/ jessie main contrib non-free rpi" /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y install git liblept4 python python-crypto python-pycurl python-imaging tesseract-ocr zip unzip python-openssl libmozjs-24-bin
wget http://ftp.fr.debian.org/debian/pool/main/g/gcc-6/gcc-6-base_6.3.0-18+deb9u1_armhf.deb
dpkg -i gcc-6-base_6.3.0-18+deb9u1_armhf.deb
rm gcc-6-base_6.3.0-18+deb9u1_armhf.deb
wget http://ftp.fr.debian.org/debian/pool/main/g/gcc-6/libgcc1_6.3.0-18+deb9u1_armhf.deb
dpkg -i libgcc1_6.3.0-18+deb9u1_armhf.deb
rm libgcc1_6.3.0-18+deb9u1_armhf.deb
wget http://ftp.fr.debian.org/debian/pool/main/g/gcc-6/libstdc++6_6.3.0-18+deb9u1_armhf.deb
dpkg -i libstdc++6_6.3.0-18+deb9u1_armhf.deb
rm libstdc++6_6.3.0-18+deb9u1_armhf.deb
wget http://ftp.fr.debian.org/debian/pool/main/g/glibc/libc6_2.24-11+deb9u3_armhf.deb
dpkg -i libc6_2.24-11+deb9u3_armhf.deb
rm libc6_2.24-11+deb9u3_armhf.deb
wget http://ftp.fr.debian.org/debian/pool/non-free/u/unrar-nonfree/unrar_5.3.2-1+deb9u1_armhf.deb
dpkg -i unrar_5.3.2-1+deb9u1_armhf.deb
rm unrar_5.3.2-1+deb9u1_armhf.deb
sudo apt-get -y build-dep rar unrar-nonfree
sudo apt-get source -b unrar-nonfree
sudo dpkg -i unrar_*_armhf.deb
sudo rm -rf unrar-*
sudo adduser --system pyload
cd /opt
sudo git clone -b stable https://github.com/pyload/pyload.git
cd pyload
whiptail --msgbox "Vous allez ici configurer pyload  " 10 80 1
sudo -u pyload python pyLoadCore.py
sudo echo """[Unit]
Description=Python Downloader
After=network.target

[Service]
User=pyload
ExecStart=/usr/bin/python /opt/pyload/pyLoadCore.py

[Install]
WantedBy=multi-user.target""" > /etc/systemd/system/pyload.service
sudo systemctl enable pyload.service
sudo service pyload restart
echo "Installation effectuée !"


fi }

################################################################
##                   Stopped French Version.                  ##
################################################################
