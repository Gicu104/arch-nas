#!/bin/bash

SOURCE="/mnt/data/syncthing"
BACKUP_ROOT="/mnt/data/backup"
TODAY=$(date +%F)
FOLDERS=("phone_android" "phone_ios" "cloudshare" "mediavault")

echo "[+] Starting segmented backup for $TODAY"
for folder in "${FOLDERS[@]}"; do
      SRC_PATH="$SOURCE/$folder"
      DEST_DIR="$BACKUP_ROOT/$folder"
      mkdir -p "$DEST_DIR"
      DEST_PATH="$DEST_DIR/${TODAY}-FULL"
      echo "  ↪ FULL backup of $folder → $DEST_PATH"
      rsync -a --delete "$SRC_PATH/" "$DEST_PATH/"
      ln -sfn "$DEST_PATH" "$DEST_DIR/latest-full"
      if [ -z "$(ls -A "$DEST_PATH" 2>/dev/null || true)" ]; then
        echo "  ↪ [!] Backup for $folder is empty!"
      else
        echo "  ↪ Backup for $folder completed."
      fi
done
echo "[✓] All backups completed for $TODAY"
