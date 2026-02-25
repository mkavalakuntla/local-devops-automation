#!/bin/bash

set -e
set -u
set -o pipefail

########################################################################################
#
# Author	: Mani Kumar
# Date		: 23/02/2026
# Script	: Cleanup of Old Backups(Automatic Retention Policy)
# Purpose 	: To enable retution policy so that script automatically deletes the old backup file from the backup path based on retention period
# Usage		: /home/devops/local-devops-automation/scripts/cleanup.sh
#
########################################################################################

# Create a reusable log function

DATE_FORMAT="%F %T"

log(){
	local LOG_STATUS="$1"
	local LOG_MESSAGE="$2"
	local TIME_STAMP="$(date +"$DATE_FORMAT")"
	local LOG_ENTRY="$TIME_STAMP [ $LOG_STATUS ] $LOG_MESSAGE"

	echo "$LOG_ENTRY" >> "$LOG_PATH/backup_cleanup.log"
}

# Validate Arguments count 

if [ $# -nq 1 ];then
	echo "[ ERROR ] Invalid number of arguments."
	echo "[ USAGE ] ./cleanup.sh <source_dir> <log_dir>"
	exit 1
fi

# Initialize the variables

BACKUPS_PATH="/home/devops/local-devops-automation/backups"
LOG_PATH="/home/devops/local-devops-automation/logs"
RETUNTION_PERIOD=7

# Write a backups cleanup function based on retention period


