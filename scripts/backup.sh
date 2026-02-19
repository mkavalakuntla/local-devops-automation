#!/bin/bash
set -euo pipefail
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

# Step-2: check the directories exist or not

if [ ! -d "$SOURCE_DIR" ];then
	echo "ERROR: The $SOURCE_DIR does not exits !"
	exit 1
fi

if [ ! -d "$DESTINATION_DIR" ];then

	echo "ERROR: The $DESTINATION_DIR does not exist!"
	mkdir -p "$DESTINATION_DIR"
fi

# Step-3 : Navigate to the backup folder and compress the  backup folder

get_backup(){
	
	local BACKUP_FILE="$DESTINATION_DIR/backup_TS_$(date +"%Y%m%d_%H%M").tar.gz"

	if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")";then
	
		echo "$BACKUP_FILE"
		return 0
	else
		return 1
	fi
}

RESULT="$(get_backup)"

# Check the backup zip directory is created or not in destination directory

if [ ! -f "$RESULT" ];then
	
	echo "ERROR: The backup file $RESULT does not created"
	exit 1
else
	echo "Backup created at $RESULT"

fi

