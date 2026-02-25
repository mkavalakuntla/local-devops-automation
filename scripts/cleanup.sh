#!/bin/bash

set -e
set -u
set -o pipefail

########################################################################################
#
# Author	: Mani Kumar
# Date		: 23/02/2026
# Script	: Cleanup of Old Backups(Automatic Retention Policy)
# Purpose 	: To enable retention policy so that script automatically deletes the old backup file from the backup path based on retention period
# Usage		: /home/devops/local-devops-automation/scripts/cleanup.sh
#
########################################################################################

# Create a reusable log function

DATE_FORMAT="%F %T"

# Validate Arguments count 

if [ $# -ne 2 ];then
	echo "[ ERROR ] Invalid number of arguments."
	echo "[ USAGE ] ./cleanup.sh <source_dir> <log_dir>"
	exit 1
fi

# Initialize the variables

BACKUPS_PATH="$1"
LOG_PATH="$2"
RETENTION_PERIOD=7


# Create a log directory

mkdir -p "$LOG_PATH"

log(){
        local LOG_STATUS="$1"
        local LOG_MESSAGE="$2"
        local TIME_STAMP="$(date +"$DATE_FORMAT")"
        local LOG_ENTRY="$TIME_STAMP [ $LOG_STATUS ] $LOG_MESSAGE"

        echo "$LOG_ENTRY" >> "$LOG_PATH/backup_cleanup.log"
}

# Check the backup directory

if [ ! -d "$BACKUPS_PATH" ];then

	log ERROR "Backup directory does not exist: $BACKUPS_PATH"
	exit 1
fi

