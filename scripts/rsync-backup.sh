#!/bin/bash
set -e

SOURCE="/mnt/data/syncthing"
BACKUP_ROOT="/mnt/data/backup/snapshots"
TODAY=$(date +%F)
SNAPSHOT="$BACKUP_ROOT/$TODAY"

# Keep only 7 snapshots
MAX_SNAPSHOTS=7

echo "[+] Starting backup snapshot: $SNAPSHOT"
mkdir -p "$SNAPSHOT"
rsync -a --delete "$SOURCE/" "$SNAPSHOT/"

# Rotate old snapshots
cd "$BACKUP_ROOT"
echo "[+] Rotating old snapshots..."
ls -1t | tail -n +$((MAX_SNAPSHOTS + 1)) | xargs -r rm -rf

echo "[✓] Backup complete: $SNAPSHOT"
