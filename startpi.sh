
#!/bin/sh
################################################################
##       Assistant de configuration StartPi par @zonguin      ##
################################################################
##        Veuillez éxécuter le script en tant que root        ##
################################################################


############### FOR COMMENTS CHECK ENGLISH VERSION ###############

{ if
which whiptail >/dev/null;
then
:
else
sudo apt-get install -y whiptail # install whiptail to create menus
fi }

sudo -l > /dev/null # Verify the user has permissions

CURRENTUSER="$(whoami)"
# This get the username of the user

mkdir /etc/startpi # create startpi folders
mkdir /etc/startpi/backups
mkdir /etc/startpi/backups/host


{ if
(whiptail --title "Langage" --yes-button "No" --no-button "Yes" --yesno "Use French Version ? " 10 80)
then
    echo "$CURRENTUSER n' a pas activé Langage" | sudo tee --append /etc/startpi/log.txt # Add data to the log file

    echo "Starting with English Version..."




################################################################
##                       English Version                      ##
################################################################

    echo "Welcome into StartPi configuration tool for Raspberry Pi by @zonguin !"

    { if
    (whiptail --title "RPiUpdate" --yes-button "No" --no-button "Yes" --yesno "Update system (Extremely recommended) ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé RPiUpdate" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé RPiUpdate" | sudo tee --append /etc/startpi/log.txt

    echo "Updating system..."

    sudo apt-get install -y
    sudo apt-get upgrade -y #install and upgrade system
    sudo apt-get dist-upgrade

    echo "Update finished !"


    fi }

    { if
    (whiptail --title "ChangeName" --yes-button "No" --no-button "Yes" --yesno "Change user pi name ?  - You must be connected as root (command : su) ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé ChangeName" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé ChangeName" | sudo tee --append /etc/startpi/log.txt

    echo "Changing pi name..."

    NEW_PINAME=$(whiptail --inputbox "Entrez le nouveau nom d' utilisateur" 10 80 "pi" 3>&1 1>&2 2>&3)
    sudo usermod --login $NEW_PINAME  --home /home/$NEW_PINAME --move-home pi #change pi user name and move files to the new folder
    echo "Done !"


    fi }

    { if
    (whiptail --title "ChangeSSHport" --yes-button "No" --no-button "Yes" --yesno "Change ssh port (Recommended for more security) ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé ChangeSSHport" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé ChangeSSHport" | sudo tee --append /etc/startpi/log.txt

    echo "Updating system..."

    SSH_PORT=$(whiptail --inputbox "Enter the new port (choose beetween 1024 and 65535) " 10 80 "22" 3>&1 1>&2 2>&3) #choose a correct port
        { if (("$SSH_PORT" > 220 && "$SSH_PORT" < 65535))
        then
        sed -i "s/^Port .*/Port "$SSH_PORT"/g" /etc/ssh/sshd_config #change the port in sshd_config
        echo "Done !"
        else
        echo "$SSH_PORT"
        echo "Incorrect port"
        fi }

    fi }

    { if
    (whiptail --title "SSHSecurity" --yes-button "No" --no-button "Yes" --yesno "Apply security modifications to the SSH ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé SSHSecurity" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé SSHSecurity" | sudo tee --append /etc/startpi/log.txt

    echo "Loading..."

    SSH_TRY=$(whiptail --inputbox "How many Auth tries before SSH auto-logout ? " 10 80 "2" 3>&1 1>&2 2>&3) #ask user

    sed -i "$ a MaxAuthTries "$SSH_TRY"" /etc/ssh/sshd_config #add security line : MaxAuthTries

    SSH_USERS=$(whiptail --inputbox "Which user is allowed to use the SSH [only one user] " 10 80 "pi" 3>&1 1>&2 2>&3)

    sed -i "$ a AllowUsers "$SSH_USERS"" /etc/ssh/sshd_config # add secrity line : AllowUsers

    sed -i "$ a LoginGraceTime 1m" /etc/ssh/sshd_config


    echo "SSH Secured !"

    fi }


    { if
    (whiptail --title "ChangeHostName" --yes-button "No" --no-button "Yes" --yesno "Change Raspberry Name ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé ChangeHostName" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé ChangeHostName" | sudo tee --append /etc/startpi/log.txt

    echo "Loading..."

    OLD_HOST=`cat /etc/hostname | tr -d " \t\n\r"`
    NEW_HOST=$(whiptail --inputbox "Please enter a hostname" 10 80 "$OLD_HOSTNAME" 3>&1 1>&2 2>&3)
    sudo cp /etc/hosts /etc/startpi/backups/host/ # backup the hosts file
    sudo cp /etc/hostname /etc/startpi/backups/host/
    sudo echo "NEW_HOST=$NEW_HOST"
    sudo echo "$NEW_HOST" > /etc/hostname #change hostname
    sudo sed -i "s/127.0.1.1.*$OLD_HOST/127.0.1.1\t$NEW_HOST/g" /etc/hosts #remplace the host name

    echo "Done !"

    fi }


    { if
    (whiptail --title "NodeUpdate" --yes-button "No" --no-button "Yes" --yesno "Update nodejs (Recommended to create some bots) ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé NodeUpdate" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé NodeUpdate" | sudo tee --append /etc/startpi/log.txt

    echo "Updating nodejs..."

    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - # install the installation script
    sudo apt install nodejs


    echo "Updated !"


    fi }

    { if
    (whiptail --title "Ruby" --yes-button "No" --no-button "Yes" --yesno "Installer Ruby (Recommended to create some bots) ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé Ruby" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé Ruby" | sudo tee --append /etc/startpi/log.txt

    echo "Installation..."

    apt-get install dirmngr
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB # add keys for the next command
    curl -sSL https://get.rvm.io | bash -s stable -s stable --autolibs=3 --ruby --rails # install ruby
    sudo /usr/sbin/usermod -a -G rvm $USER # add permissions
    sudo chown root.rvm /etc/profile.d/rvm.sh
    source /usr/local/rvm/scripts/rvm # launch ruby


    echo "Installation done !"


    fi }

    { if
    (whiptail --title "OtherUpdates" --yes-button "No" --no-button "Yes" --yesno "Update / Install some others frameworks [recommended for some Auto Install in StartPi] ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé OtherUpdates" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé OtherUpdates" | sudo tee --append /etc/startpi/log.txt

    echo "Updating..."


    mkdir  /tmp/startpi
    cd /tmp/startpi
    sudo apt-get update
    wget https://cpan.metacpan.org/authors/id/A/AN/ANDK/CPAN-2.16.tar.gz # download cpan update
    tar zxf CPAN-2.16.tar.gz
    perl Makefile.PL
    make test
    sudo make install # install cpan
    sudo apt-get install yarn
    npm install -g steem discord.js moment bufferutil erlpack node-opus opusscript  sodium libsodium-wrappers uws mathjs convnetjs # install npm modules
    sudo apt-get -y install git
    apt-get install pm2

    echo "Updated !"

    rm -rf /tmp/startpi


    fi }

    { if
    (whiptail --title "DelGraphic" --yes-button "No" --no-button "Yes" --yesno "Delete some useless packets [Only raspbian Lite / No graphic interface] ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé DelGraphic" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé DelGraphic" | sudo tee --append /etc/startpi/log.txt

    echo "Cleaning..."

    apt-get -y remove --purge xserver-common x11-common gnome-icon-theme gnome-themes-standard penguinspuzzle # remove packets
    apt-get -y remove --purge desktop-base desktop-file-utils hicolor-icon-theme raspberrypi-artwork omxplayer
    apt-get -y autoremove

    echo "Done !"


    fi }

    whiptail --title "partie Utilitaires" --yes-button "No" --no-button "yes" --yesno "you enter in part [Utilities Installation] ?" 10 80
    { if
    (whiptail --title "usbmount" --yes-button "No" --no-button "Yes" --yesno "Install usbmount to mount / unmount usb devices automaticaly when plugged ?" 10 80)
    then
    echo "$CURRENTUSER n' a pas activé usbmount" | sudo tee --append /etc/startpi/log.txt
    else
    echo "$CURRENTUSER a activé usbmount" | sudo tee --append /etc/startpi/log.txt

    echo "Installation..."

    apt-get install usbmount

    echo "Installation done !"


    fi }

    echo "Program ended. Thanks for using StartPi by @zonguin !"



################################################################
##                   Stopped English Version                  ##
################################################################


else
echo "$CURRENTUSER a activé Langage" | sudo tee --append /etc/startpi/log.txt

echo "Starting with French Version..."

echo "Bienvenue dans l' assistant de configuration StartPi par @zonguin !"


################################################################
##                       French Version.                      ##
################################################################


{ if
(whiptail --title "RPiUpdate" --yes-button "Non" --no-button "Oui" --yesno "Mettre à jour le système (Vivement recommandé) ?" 10 80)
then
echo "$CURRENTUSER n' a pas activé RPiUpdate" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER a activé RPiUpdate" | sudo tee --append /etc/startpi/log.txt

echo "Mise à jour du système..."

sudo apt-get install -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade

echo "Mise à jour effectuée !"


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


fi }

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
else
echo "$CURRENTUSER a activé DelGraphic" | sudo tee --append /etc/startpi/log.txt

echo "Nettoyage en cours..."

apt-get -y remove --purge xserver-common x11-common gnome-icon-theme gnome-themes-standard penguinspuzzle
apt-get -y remove --purge desktop-base desktop-file-utils hicolor-icon-theme raspberrypi-artwork omxplayer
apt-get -y autoremove

echo "nettoyage effectué !"


fi }

whiptail --title "partie Utilitaires" --yes-button "Non" --no-button "Oui" --yesno "Vous entrez dans la partie [Installation d' utilitaires] ?" 10 80
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




################################################################
##                   Stopped French Version.                  ##
################################################################

sudo systemctl restart ssh

## END
unset CURRENTUSER
unset NEW_PINAME
unset SSH_PORT
unset SSH_TRY
unset SSH_USERS
