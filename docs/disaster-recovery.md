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

### 0. Boot Live ISO and Connect
- Boot from Arch ISO USB
- Connect to internet (Wi-Fi or Ethernet)

### 1. Partition Internal Storage

```
cfdisk /dev/mmcblk0
# Create:
# mmcblk0p1 – EFI System Partition (512MB, type EF00)
# mmcblk0p2 – Linux Swap partition (512MB, type swap)
# mmcblk0p3 – Root Partition (rest of the space, Linux root / 64)
```
2. Format and Mount
```
partprobe /dev/mmcblk0
mkfs.fat /dev/mmcblk0p1
mkfs.ext4 /dev/mmcblk0p3
mkswap /dev/mmcblk0p2
mount /dev/mmcblk0p3 /mnt
mount --mkdir /dev/mmcblk0p1 /mnt/boot
swapon /dev/mmcblk0p2
```
3. Pacstrap and Chroot
```
pacstrap /mnt base linux linux-firmware sudo networkmanager
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```
4. Clone Setup Repo and Run
```
pacman -Sy git
git clone https://github.com/Gicu104/arch-nas.git /root/arch-nas
cd /root/arch-nas/setup
bash arch-setup.sh config.conf
```
5. Install GRUB (UEFI)
```
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```
6. Exit, Reboot and pray for best 
```
exit
umount -R /mnt
reboot
```
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
