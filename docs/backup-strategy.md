# Backup Strategy

My goal is to ensure that all critical data is backed up to external locations and can be restored easily.

## External HDD Backup
1. Use **rsync** or **Btrfs snapshots** for scheduled backups.
2. Store all important data (Syncthing folders, configurations) on an external HDD.
3. Use **Syncthing** to sync important folders to another machine or cloud storage.

## Offsite Backup
- Cloud sync (using Tailscale) to another device in a remote location.
