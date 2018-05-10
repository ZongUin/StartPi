
#!/bin/sh
################################################################
##       Assistant de configuration StartPi par @zonguin      ##
################################################################
##        Veuillez éxécuter le script en tant que root        ##
################################################################


{ if
which whiptail >/dev/null;
then
:
else
sudo apt-get install -y whiptail
fi }

CURRENTUSER="$(whoami)"

mkdir /etc/startpi
mkdir /etc/startpi/backups
mkdir /etc/startpi/backups/host

echo "Bienvenue dans l' assistant de configuration StartPi par @zonguin !"


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
    sed -i "s/^Port .*/Port "$SSH_PORT"/g" /etc/ssh/sshd_config
    echo "Mise à jour effectuée !"
    else
    echo "$SSH_PORT"
    echo "Erreur : Port incorrect"
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
NEW_HOST=$(whiptail --inputbox "Please enter a hostname" 10 80 "$OLD_HOSTNAME" 3>&1 1>&2 2>&3)
sudo cp /etc/hosts /etc/startpi/backups/host/
sudo cp /etc/hostname /etc/startpi/backups/host/
sudo echo "NEW_HOST=$NEW_HOST"
sudo echo "$NEW_HOST" > /etc/hostname
sudo sed -i "s/127.0.1.1.*$OLD_HOST/127.0.1.1\t$NEW_HOST/g" /etc/hosts

echo "Changement effectué !"

fi }



## END
unset CURRENTUSER
unset NEW_PINAME
unset SSH_PORT
