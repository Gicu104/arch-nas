#!/bin/bash

BACKUP_FILE="/mnt/data/backup/last-successfull-backup"
TODAY=$(date +%F)

# Extract the modification date of the backup file (YYYY-MM-DD)
MOD_DATE=$(stat "$BACKUP_FILE" | grep '^Modify:' | cut -d' ' -f2)

if [ "$MOD_DATE" = "$TODAY" ]; then
    echo "Backup file was complete today ($TODAY)."
else
    echo "[ALERT] Backup script did not complete for $TODAY at $(date)" >> /var/log/alerts/backup-alert.log
    exit 1
fi
