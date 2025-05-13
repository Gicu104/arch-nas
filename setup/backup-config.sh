#!/bin/bash
set -e

BACKUP_DIR="/mnt/data/backup-configs"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="arch-config-backup_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

# Create tarball safely, suppress warnings for missing files
tar -czvf "$BACKUP_DIR/$ARCHIVE_NAME" --ignore-failed-read \
    /etc/fstab \
    /etc/hostname \
    /etc/hosts \
    /etc/NetworkManager/system-connections/ \
    /etc/modprobe.d/blacklist-dma.conf \
    /etc/ssh/sshd_config \
    /etc/sudoers.d/99_wheel \
    /home/gicu/arch-nas/setup/arch-setup.sh \
    /home/gicu/arch-nas/setup/config.conf

echo "✅ Backup complete: $BACKUP_DIR/$ARCHIVE_NAME"
