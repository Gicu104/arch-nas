# Folder Structure

Defines the storage layout used on the mounted external HDD at `/mnt/data`.

## Mount Point
All persistent data is located under:

`/mnt/data`

## Top-Level Folders
```plaintext
/mnt/data/
├── syncthing/
└── backup/
```
## 1. Syncthing

`/mnt/data/syncthing/` is managed by Syncthing. Real-time sync from devices.
```plaintext
/mnt/data/syncthing/
├── phone_android/
|   ├──android1/
|   └──android2/
├── phone_ios/
|   └──iphone1
├── cloudshare/
└── mediavault/
```
- `phone_android/`: synced photos, docs, etc. from Android, new branches for each phone
- `phone_ios/`: same for iOS, new branches for each iphone
- `cloudshare/`: universal sync folder, used by PC and all phones, lightweight cloud
- `mediavault`: media folder for heavy files, only for PC

This is your **live cloud**, always up-to-date.

## 2. Backup

`/mnt/data/backup/` is used for **manual or automated snapshots** of the synced data.
```plaintext
/mnt/data/backup/
├── phone_android/
├── phone_ios/
├── cloudshare/
└── mediavault/
```
- Mirrors the syncthing layout
- Can be used for:
  - Manual rsync backups
  - Cron jobs
  - Incremental snapshots with tools like `rsnapshot`, `borg`, or `restic`
  - Future cold-storage or off-site backups

## Summary

- 🔁 Syncthing handles live sync
- 🧱 Backup is cold, controlled, and safe
- 📁 Single entrypoint = `/mnt/data`
