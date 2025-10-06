#!/bin/bash
set -euo pipefail

SOURCE="/mnt/data/syncthing"
BACKUP_ROOT="/mnt/data/backup"
TODAY=$(date +%F)
DAY_OF_WEEK=$(date +%u)   # 1 = Monday, 7 = Sunday
FOLDERS=("phone_android" "phone_ios" "cloudshare" "mediavault")

echo "[+] Starting segmented backup for $TODAY"

for folder in "${FOLDERS[@]}"; do
    SRC_PATH="$SOURCE/$folder"
    DEST_DIR="$BACKUP_ROOT/$folder"
    mkdir -p "$DEST_DIR"

    # Decide if today is FULL or INC
    if [ "$DAY_OF_WEEK" -eq 7 ]; then
        # Sunday → make FULL
        DEST_PATH="$DEST_DIR/${TODAY}-FULL"
        echo "  ↪ FULL backup of $folder → $DEST_PATH"
        rsync -a --delete "$SRC_PATH/" "$DEST_PATH/"

        # Update symlink "latest-full"
        ln -sfn "$DEST_PATH" "$DEST_DIR/latest-full"
    else
        # Incremental → based on latest-full
        if [ ! -L "$DEST_DIR/latest-full" ]; then
            echo "  [!] No full backup found for $folder. Skipping incremental."
            continue
        fi
        DEST_PATH="$DEST_DIR/${TODAY}-INC"
        echo "  ↪ Incremental backup of $folder → $DEST_PATH"
        rsync -a --delete --link-dest="$DEST_DIR/latest-full" "$SRC_PATH/" "$DEST_PATH/"
    fi

    # Validation: check if backup dir is non-empty
    if [ -z "$(ls -A "$DEST_PATH" 2>/dev/null || true)" ]; then
        echo "  ↪ [!] Backup for $folder is empty!"
    else
        echo "  ↪ Backup for $folder completed."
    fi

    # Rotate old backups (keep 2 full backups and their incrementals)
    echo "  ↪ Rotating old backups in /$folder"
    cd "$DEST_DIR"

    # Find full backups, newest first
    FULL_BACKUPS=( $(ls -1d *-FULL 2>/dev/null | sort -r || true) )
    
    if [ ${#FULL_BACKUPS[@]} -gt 2 ]; then
        echo "    ↪ Keeping 2 newest full backups: ${FULL_BACKUPS[0]} and ${FULL_BACKUPS[1]}"
    
        # Delete all older full backups
        for old_full in "${FULL_BACKUPS[@]:2}"; do
            echo "    ↪ Removing old full backup $old_full"
            rm -rf "$old_full"
        done
    fi
    
    # After cleanup, find the oldest full backup that remains
    FULL_BACKUPS=( $(ls -1d *-FULL 2>/dev/null | sort -r || true) )
    if [ ${#FULL_BACKUPS[@]} -gt 0 ]; then
        OLDEST_FULL="${FULL_BACKUPS[-1]}"
        OLDEST_DATE=$(echo "$OLDEST_FULL" | cut -d- -f1-3)
    
        echo "    ↪ Removing all incrementals older than $OLDEST_DATE"
        for inc in *-INC; do
            inc_date=$(echo "$inc" | cut -d- -f1-3)
            if [[ "$inc_date" < "$OLDEST_DATE" ]]; then
                echo "      ↪ Removing incremental $inc"
                rm -rf "$inc"
            fi
        done
    fi    
done

echo "[✓] All backups completed for $TODAY"
