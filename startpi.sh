
#!/bin/sh
################################################################
##                     StartPi by @zonguin                    ##
################################################################
##           Please start the script with root user           ##
################################################################

# Set Colors for the echo command

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"


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
cp /etc/startpi/log.txt /etc/startpi/logback.txt # save last backup : 2 backups will be available
rm /etc/startpi/log.txt  # start a new backup by deleting previous backup

chmod +x en.sh # Give permissions to execute StartPi
chmod +x fr.sh




{ if
(whiptail --title "Langage" --yes-button "No" --no-button "Yes" --yesno "Use French Version ? " 10 80)
then
echo "$CURRENTUSER use English langage" | sudo tee --append /etc/startpi/log.txt # Add data to the log file
echo "Starting with English Version..."

sudo ./en.sh

else
echo "$CURRENTUSER a utilisé le language Français" | sudo tee --append /etc/startpi/log.txt

echo "Starting with French Version..."

echo "Bienvenue dans l' assistant de configuration StartPi par @zonguin !"

sudo ./fr.sh

fi }

sudo systemctl restart ssh

## END
unset CURRENTUSER
unset NEW_PINAME
unset SSH_PORT
unset SSH_TRY
unset SSH_USERS
