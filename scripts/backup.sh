#!/bin/bash
set -euo pipefail

############################################################################################
#
# Author  : Mani Kumar
# Date    : 18/02/2026
# Script  : backup.sh
# Purpose : Take backup of a folder and save it in another folder with timestamp.
# Usage   : ./backup.sh <source_dir> <destination_dir>
#
############################################################################################

#############################################
# Exit Codes
# 1 -> Invalid arguments
# 2 -> Source directory missing
# 3 -> Backup (tar) failed
# 4 -> Backup file not created
#############################################

DATE_FORMAT="+%F %T"

# Creating a reusable log function

log(){
        LOG_LEVEL="$1"
        LOG_MESSAGE="$2"
        TIME_STAMP="$(date "$DATE_FORMAT")"

        LOG_ENTRY="$TIME_STAMP [ $LOG_LEVEL ] $LOG_MESSAGE"
	echo "$LOG_ENTRY" >> "$LOG_PATH/backup.log"

}

# Validate argument count
if [ $# -ne 3 ]; then
    echo "[ ERROR ] Invalid number of arguments."
    echo "[ USAGE ] ./backup.sh <source_dir> <destination_dir> <log_dir>"
    exit 1
fi

# Assign arguments
SOURCE_DIR="$1"
DESTINATION_DIR="$2"
LOG_PATH="$3"

# Ensure log directory path exists
mkdir -p "$LOG_PATH"

log INFO "Starting backup process..."
log INFO "Source: $SOURCE_DIR"
log INFO "Destination: $DESTINATION_DIR"

# Validate source directory
if [ ! -d "$SOURCE_DIR" ]; then
    log ERROR "Source directory does not exist: $SOURCE_DIR"
    exit 2
fi

# Validate / create destination directory
if [ ! -d "$DESTINATION_DIR" ]; then
    log WARN "Destination directory not found. Creating..."
    mkdir -p "$DESTINATION_DIR"
fi

# Backup function
get_backup() {
    local BACKUP_FILE="$DESTINATION_DIR/backup_TS_$(date +"%Y%m%d_%H%M").tar.gz"

    if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"; then
        echo "$BACKUP_FILE"

        return 0
    else
        return 3
    fi
}

# Execute backup

BACKUP_RESULT="$(get_backup)" || {
    log ERROR "Backup failed during tar execution"
    exit 3
}

# Verify backup file creation
if [ ! -f "$BACKUP_RESULT" ]; then
    log ERROR "Backup file was not created: $BACKUP_RESULT"
    exit 4
fi

log INFO "Backup created successfully at: $BACKUP_RESULT"

exit 0
