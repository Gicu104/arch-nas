# Backup Strategy

My goal is to ensure that all critical data is backed up to external locations and can be restored easily.

## External HDD Backup
1. Use **rsync** for scheduled backups.
2. Store all important data (Syncthing folders, configurations) on an external HDD.
3. Use **Syncthing** to sync important folders to another machine or cloud storage.

## Offsite Backup
- Cloud sync (using Tailscale) to another device in a remote location.

# Actual backup done
- Structure of backups (mirrored + snapshots)
- Snapshot interval (daily)
- Retention policy (7 days)
- Tools used (**rsync**, **cron**)
- Script is located at `home/gicu/scripts/rsync-backup.sh` and in repo in scripts
- Logs are located at `/var/log/rsync-backup.log`
- To restore data from 2025-06-01 snapshot:
```
rsync -a /mnt/data/backup/snapshots/2025-06-01/ /mnt/data/syncthing/
```
