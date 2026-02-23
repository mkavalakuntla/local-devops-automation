#!/bin/bash

########################################################################################
#
# Author	: Mani Kumar
# Date		: 23/02/2026
# Script	: Cleanup of Old Backups(Automatic Retention Policy)
# Purpose 	: To enable retution policy so that script automatically deletes the old backup file from the backup path based on retention period
# Usage		: /home/devops/local-devops-automation/scripts/cleanup.sh
#
########################################################################################


log(){
	local LOG_STATUS="$1"
	local LOG_MESSAGE="$2"
	local TIME_STAMP="$(date +%F %T)"
	



# Initialize the variables

BACKUP_DIR="/home/devops/local-devops-automation/backups"
LOG_FILE="/home/devops/local-devops-automation/logs/cleanup.log"
RETENTION_DAYS=7

# Check the backup directory exist or not


