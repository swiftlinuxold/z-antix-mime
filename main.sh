#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit
fi

USERNAME=$(logname)
IS_CHROOT=0

# The remastering process uses chroot mode.
# Check to see if this script is operating in chroot mode.
# If /home/$USERNAME exists, then we are not in chroot mode.
if [ -d "/home/$USERNAME" ]; then
	IS_CHROOT=0 # not in chroot mode
	DIR_DEVELOP=/home/$USERNAME/develop 
else
	IS_CHROOT=1 # in chroot mode
	DIR_DEVELOP=/usr/local/bin/develop 
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
