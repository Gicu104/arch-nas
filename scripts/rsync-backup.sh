#!/bin/bash
set -e

SOURCE="/mnt/data/syncthing"
BACKUP_ROOT="/mnt/data/backup"
TODAY=$(date +%F)
MAX_SNAPSHOTS=7

FOLDERS=("phone_android" "phone_ios" "cloudshare" "mediavault")

echo "[+] Starting segmented backup for $TODAY"

for folder in "${FOLDERS[@]}"; do
    SRC_PATH="$SOURCE/$folder"
    DEST_PATH="$BACKUP_ROOT/$folder/$TODAY"

    echo "  ↪ Backing up $folder → $DEST_PATH"
    mkdir -p "$DEST_PATH"

    rsync -a --delete "$SRC_PATH/" "$DEST_PATH/"

    echo "  ↪ Rotating snapshots in /$folder"
    cd "$BACKUP_ROOT/$folder"
    ls -1t | tail -n +$((MAX_SNAPSHOTS + 1)) | xargs -r rm -rf
done

echo "[✓] All backups completed for $TODAY"
