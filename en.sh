################################################################
##                       English Version                      ##
################################################################

RED="\033[0;31m" #set colors for terminal
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

echo "Welcome into StartPi configuration tool for Raspberry Pi by @zonguin !"

{ if
(whiptail --title "RPiUpdate" --yes-button "No" --no-button "Yes" --yesno "Update system (Extremely recommended) ?" 10 80) # Menu
then
echo "$CURRENTUSER not activate RPiUpdate" | sudo tee --append /etc/startpi/log.txt # logging
else
echo "$CURRENTUSER activate RPiUpdate" | sudo tee --append /etc/startpi/log.txt

echo "Updating system..."

sudo apt-get install -y
sudo apt-get upgrade -y #install and upgrade system
sudo apt-get dist-upgrade

echo "Update finished !"


fi }

{ if
(whiptail --title "ChangeName" --yes-button "No" --no-button "Yes" --yesno "Change user pi name ?  - You must be connected as root (command : su) ?" 10 80) # Menu
then
echo "$CURRENTUSER not activate ChangeName" | sudo tee --append /etc/startpi/log.txt #logging
else
echo "$CURRENTUSER activate ChangeName" | sudo tee --append /etc/startpi/log.txt

echo "Changing pi name..."

NEW_PINAME=$(whiptail --inputbox "Entrez le nouveau nom d' utilisateur" 10 80 "pi" 3>&1 1>&2 2>&3)
sudo usermod --login $NEW_PINAME  --home /home/$NEW_PINAME --move-home pi #change pi user name and move files to the new folder
echo "Done !"


fi }

{ if
(whiptail --title "ChangeSSHport" --yes-button "No" --no-button "Yes" --yesno "Change ssh port (Recommended for more security) ?" 10 80)
then
echo "$CURRENTUSER not activate ChangeSSHport" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER activate ChangeSSHport" | sudo tee --append /etc/startpi/log.txt

echo "Updating system..."

SSH_PORT=$(whiptail --inputbox "Enter the new port (choose beetween 1024 and 65535) " 10 80 "22" 3>&1 1>&2 2>&3) #choose a correct port
    { if (("$SSH_PORT" > 220 && "$SSH_PORT" < 65535)) # check that it is a correct port
    then
    sed -i "s/^Port .*/Port "$SSH_PORT"/g" /etc/ssh/sshd_config #change the port in sshd_config
    echo "Done !"
    else
    echo "$SSH_PORT" # incorrect port --> error
    echo "Incorrect port"
    fi }

fi }

{ if
(whiptail --title "SSHSecurity" --yes-button "No" --no-button "Yes" --yesno "Apply security modifications to the SSH ?" 10 80) # Menu
then
echo "$CURRENTUSER not activate SSHSecurity" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER activate SSHSecurity" | sudo tee --append /etc/startpi/log.txt

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
echo "$CURRENTUSER not activate ChangeHostName" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER activate ChangeHostName" | sudo tee --append /etc/startpi/log.txt

echo "Loading..."

OLD_HOST=`cat /etc/hostname | tr -d " \t\n\r"` # check old hostname
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
echo "$CURRENTUSER not activate NodeUpdate" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER activate NodeUpdate" | sudo tee --append /etc/startpi/log.txt

echo "Updating nodejs..."

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - # install the installation script
sudo apt install nodejs


echo "Updated !"


fi }

{ if
(whiptail --title "Ruby" --yes-button "No" --no-button "Yes" --yesno "Installer Ruby (Recommended to create some bots) ?" 10 80)
then
echo "$CURRENTUSER not activate Ruby" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER activate Ruby" | sudo tee --append /etc/startpi/log.txt

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
echo "$CURRENTUSER not activate OtherUpdates" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER activate OtherUpdates" | sudo tee --append /etc/startpi/log.txt

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
echo "$CURRENTUSER not activate DelGraphic" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER activate DelGraphic" | sudo tee --append /etc/startpi/log.txt

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
echo "$CURRENTUSER not activate usbmount" | sudo tee --append /etc/startpi/log.txt
else
echo "$CURRENTUSER activate usbmount" | sudo tee --append /etc/startpi/log.txt

echo "Installation..."

apt-get install usbmount

echo "Installation done !"


fi }

echo "Program ended. Thanks for using StartPi by @zonguin !"



################################################################
##                   Stopped English Version                  ##
################################################################
