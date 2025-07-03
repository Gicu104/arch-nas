#!/bin/bash
SNAPSHOT_DIR="/mnt/data/backup/cloudshare/$(date +%F)"

if [ ! -d "$SNAPSHOT_DIR" ]; then
  echo "[ALERT] Backup missing for $(date +%F) at $(date)" >> /var/log/alerts/backup-alert.log
fi
