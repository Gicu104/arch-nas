#!/bin/bash
BACKUP_ROOT="/mnt/data/backup"
TODAY=$(date +%F)

# Check if backup script completed for today
if [ ! -f "$BACKUP_ROOT/backup-success-$TODAY" ]; then
    echo "[ALERT] Backup script did not complete for $TODAY at $(date)" >> /var/log/alerts/backup-alert.log
    exit 1
fi
