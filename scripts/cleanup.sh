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

echo "[ INFO ] Checking the Arguments are valid or not "

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

echo "[ INFO ] Creating the log directory"

mkdir -p "$LOG_PATH"

log(){
        local LOG_STATUS="$1"
        local LOG_MESSAGE="$2"
        local TIME_STAMP="$(date +"$DATE_FORMAT")"
        local LOG_ENTRY="$TIME_STAMP [ $LOG_STATUS ] $LOG_MESSAGE"

        echo "$LOG_ENTRY" >> "$LOG_PATH/backup_cleanup.log"
}

# Check the backup directory

log INFO "Checking the backups path is exist or not"

if [ ! -d "$BACKUPS_PATH" ];then

	log ERROR "Backup directory does not exist: $BACKUPS_PATH"
	exit 1
fi

# Check the backups more than 7 days and clear them

log INFO "Checking for backups older than $RETENTION_PERIOD days..."

OLD_BACKUPS=$(find "$BACKUPS_PATH" -type f -name "*.tar.gz" -mtime +"$RETENTION_PERIOD")

if [ -z "$OLD_BACKUPS" ];then

	log INFO "No old backup files are found."
	exit 0
else
	log INFO "Old backup files found:"
 	echo "$OLD_BACKUPS" >> "$LOG_PATH/backup_cleanup.log"

	log INFO "Deleting old backups files.."

	find "$BACKUPS_PATH" -type f -name "*.tar.gz" -mtime +"$RETENTION_PERIOD" -delete

	log INFO "Old backups are deleted successfully.."
fi

exit 0





