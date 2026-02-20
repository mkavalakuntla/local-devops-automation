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

# Validate argument count
if [ $# -ne 2 ]; then
    echo "[ERROR] Invalid number of arguments."
    echo "Usage: ./backup.sh <source_dir> <destination_dir>"
    exit 1
fi

# Assign arguments
SOURCE_DIR="$1"
DESTINATION_DIR="$2"

echo "[INFO] Starting backup process..."
echo "[INFO] Source: $SOURCE_DIR"
echo "[INFO] Destination: $DESTINATION_DIR"

# Validate source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo "[ERROR] Source directory does not exist: $SOURCE_DIR"
    exit 2
fi

# Validate / create destination directory
if [ ! -d "$DESTINATION_DIR" ]; then
    echo "[WARN] Destination directory not found. Creating..."
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

RESULT="$(get_backup)" || exit 3

# Verify backup file creation
if [ ! -f "$RESULT" ]; then
    echo "[ERROR] Backup file was not created: $RESULT"
    exit 4
fi

echo "[INFO] Backup created successfully at: $RESULT"
exit 0
