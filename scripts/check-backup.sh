#!/bin/bash
SNAPSHOT_DIR="/mnt/data/backup/snapshots/$(date +%F)"

if [ ! -d "$SNAPSHOT_DIR" ]; then
  echo "[ALERT] Backup missing for $(date +%F) at $(date)" >> /var/log/backup-alert.log
fi
