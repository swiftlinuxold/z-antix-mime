#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit 2
fi

IS_CHROOT=0 # changed to 1 if and only if in chroot mode
USERNAME=""
DIR_DEVELOP=""

# The remastering process uses chroot mode.
# Check to see if this script is operating in chroot mode.
# /srv directory only exists in chroot mode
if [ -d "/srv" ]; then
	IS_CHROOT=1 # in chroot mode
	DIR_DEVELOP=/usr/local/bin/develop 
else
	USERNAME=$(logname) # not in chroot mode
	DIR_DEVELOP=/home/$USERNAME/develop 
fi


echo "Changing Bittorrent file association"
# If /home/$USERNAME exists, change the file association in this directory.

FILE_TO_COPY=$DIR_DEVELOP/mime/MIME-types/application_x-bittorrent

if [ $IS_CHROOT -eq 0 ]; then
	rm /home/$USERNAME/.config/rox.sourceforge.net/MIME-types/application_x-bittorrent
	cp $FILE_TO_COPY /home/$USERNAME/.config/rox.sourceforge.net/MIME-types/
	chown $USERNAME:users /home/$USERNAME/.config/rox.sourceforge.net/MIME-types/application_x-bittorrent
fi

rm /etc/skel/.config/rox.sourceforge.net/MIME-types/application_x-bittorrent
cp $FILE_TO_COPY /etc/skel/.config/rox.sourceforge.net/MIME-types/
if [ $IS_CHROOT -eq 0 ]; then
	chown $USERNAME:users /etc/skel/.config/rox.sourceforge.net/MIME-types/application_x-bittorrent
else
	chown demo:users /etc/skel/.config/rox.sourceforge.net/MIME-types/application_x-bittorrent
fi

exit 0
