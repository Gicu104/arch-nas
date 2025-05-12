# Disaster Recovery Plan — Arch-NAS Fortress

**Version:** 1.0  
**Last Reviewed:** 12/05/2025

This document outlines the recovery procedures in case of failure of critical components in the Arch-NAS system. All steps are tested and tuned for Dell Wyse 3040 running headless Arch Linux.

---

## 1. Recovery Goals

- Restore NAS functionality with minimum downtime
- Retain synced data (via Syncthing)
- Avoid data loss on external storage (`/mnt/data`)
- Minimize manual steps via automation

---

## 2. Recovery Checklist

| Component                  | Backup Method                  | Recovery Steps                      |
|---------------------------|---------------------------------|-------------------------------------|
| OS + System Config        | Git repo + reinstallation script | Boot Arch ISO, run `arch-setup.sh` |
| External HDD (`/mnt/data`) | No auto-format in script        | Reattach, auto-mount via `UUID`     |
| SSH Access + Auth         | SSH key in `config.conf`        | Restore authorized_keys             |
| Syncthing config          | Manual or Syncthing resync      | Re-add folders after install        |
| Tailscale Auth            | Manual login via web            | Re-login after package reinstall    |

---

## 3. Prerequisites

- Bootable Arch USB drive
- Internet connection
- Latest version of the setup repo:  
  `git clone https://github.com/Gicu104/arch-nas.git`

- External HDD must **not be wiped** during setup. Ensure `config.conf` uses correct `HDD_UUID` and skips formatting if recovering.

---

## 4. Reinstall Procedure

Follow the standard installation process documented in [install-guide.md](./install-guide.md). Ensure you're using the latest ISO and that your configuration files are in sync with the repository.

*Tip: Keep a bootable USB stick nearby with this repo and key config files.*



## //this is mess, clean it later

5. Post-Recovery: Syncthing
Access via http://<NAS-IP>:8384

Re-approve devices

Resync shared folders

6. Post-Recovery: Tailscale
```
sudo pacman -S tailscale
sudo tailscale up
```
Approve the node in your Tailscale admin panel

7. Validate System
Confirm SSH access via key

Confirm static IP works

Test Syncthing sync

Test Tailscale remote access

Check mount: lsblk, mount | grep data

8. Backup Reminder
Backup critical files weekly to /mnt/data/backups

Include config files, Syncthing IDs, and recovery steps

Consider syncing encrypted backups to cloud or second NAS

9. Final Words
Your NAS is only as strong as its backups and documentation.
Stay paranoid, stay Arch.

“A man with no backup is one mistyped rm away from enlightenment.”
