#!/bin/bash

############################################################################################
#
# Author : Mani Kumar
# Date   : 18/02/2026
# Script name : local-devops-automation
# Purpose        : Take backup of a folder and save it another folder with timestamp.
# Usage  : ./local-devops-automation/scripts/backup.sh
#
###########################################################################################

# Step-1 : Initialise the variables

SOURCE_DIR="/home/devops/projects/backup_TS"
DESTINATION_DIR="/home/devops/backups"
TODAY_DATE_TIME=$(date +"%F_%T %p")

# Step-2: check the directories exist or not

if [ ! -d "$SOURCE_DIR" ];then
	echo "ERROR: The $SOURCE_DIR does not exits !"
	exit 1
fi

if [ ! -d "$DESTINATION_DIR" ];then

	echo "ERROR: The $DESTINATION_DIR does not exist!"
	exit 1
fi

# Step-3 : Navigate to the backup folder and compress the  backup folder

get_backup(){
	
	BACKUP_FILE="$DESTINATION_DIR/backup_TS_$(date +"%Y%m%d_%H%M").tar.gz"
	tar -czvf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
	ls -lhrt "$DESTINATION_DIR"
}

get_backup





