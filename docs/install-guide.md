# Arch Linux NAS Installation Guide

This guide walks you through installing and configuring your Arch-based NAS on the Dell Wyse 3040, using both manual steps and an automated setup script.

---

## Prerequisites

- Dell Wyse 3040 with at least 2GB of RAM 8GB of internal storage
- External HDD (1TB+) for storage
- A working internet connection

---

## Repository Contents

This repository includes:

- `arch-setup.sh`: Main setup script for system configuration, user creation, networking, and enabling headless operation.
- `config.conf`: Configuration file used by the setup script to define hostname, username, static IP, and other system settings.

---

## Installation Steps

### Step 1: Boot Arch ISO and Connect to the Internet

1. Boot the Dell Wyse using the official Arch Linux ISO.
2. Connect to the internet via Ethernet or Wi-Fi.
3. Set time and keyboard layout 
```
loadkeys pl
```
```
timedatectl set-ntp true
```
### Step 2: Prepare the Internal Storage

Partition and format the internal drive (e.g., eMMC or SSD). Mount the root partition at `/mnt`.

I used `cfdisk`
Check your disks labels
```
lsblk
```
My flash disk was named `mmcblk0`
```
cfdisk /dev/mmcblk0
```
- If prompted set `gpt`
- Wipe everything and make 3 partitions
- 512M [TYPE] EFI system
- 512M [TYPE] Linux swap
- rest [TYPE] Linux root (x86-64)
- [WRITE] then `yes` to save changes
- [QUIT]

Format partitions
```
partprobe /dev/mmcblk0
mkfs.fat /dev/mmcblk0p1
mkswap /dev/mmcblk0p2
mkfs.ext4 /dev/mmcblk0p3
```
Mount partitions
```
mount /dev/mmcblk0p3 /mnt
swapon /dev/mmcblk0p2
mount --mkdir /dev/mmcblk0p1 /mnt/boot
```
Now you can check `lsblk` if everything is in place

### Step 3: Install base system

```
pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```
### Step 4: Install Bootloader
Check if `/boot` partition is mounted
```
lsblk
```
If not 
```
mount /dev/mmcblk0p1 /boot
```
Check if EFI returns `64`
```
cat /sys/firmware/efi/fw_platform_size
```
If so you can install with code below, .cfg is generated twice bc id didnt reboot
```
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
mkdir -p /boot/EFI/BOOT
cp /boot/EFI/GRUB/grubx64.efi /boot/EFI/BOOT/BOOTX64.EFI
efibootmgr --create --disk /dev/mmcblk0 --part 1 --label "ArchLinux" --loader /EFI/GRUB/grubx64.efi
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet reboot=pci"/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
```
### Set root password or you will suffer
```
passwd
```
```
exit
```
```
umount -R /mnt
```
Prepare for reboot, unplug usb if its firts boot option
You may also delete default `GRUB` boot option and keep only `ArchLinux` option in BIOS setup (enter with `F2`) 
```
reboot
```
Wyse should boot to Arch now

### Step 5: Transfer Setup Files

Clone this repository or copy the setup files to the target system:
```
git clone https://github.com/Gicu104/arch-nas.git
cd arch-nas/setup/
```
Or use a USB stick or `scp` if you prefer.

### Step 6: Run the script

From within the live Arch environment:

```
bash arch-setup.sh config.conf
```

The script will:
- Set the hostname
- Create your main user and configure sudo
- Install base packages and enable networking
- Configure system with a static IP
- Set up locale, time, and SSH
- Prepare the system for headless operation
- Set firewall rules

### Step 7: Reboot and SSH in

Once done, reboot the machine and connect to it via SSH using the static IP defined in `config.conf`.
```
reboot
```

## Notes for script

- TThe script aims to be idempotent where possible, but use with care.
- Safe for repeated usage only if you're aware of its effects.
- `config.conf` should **never** be committed with passwords or private keys.
- All sensitive tasks (disk formatting, password setup, etc.) should be done manually for now.

## Step 8: Install Syncthing nad Tailscale
```
sudo pacman -S syncthing
sudo systemctl enable syncthing
```

Follow Tailscale's installation guide for Arch Linux.

Access Syncthing via the web UI (http://localhost:8384) and add your folders.

## Step 9: Configure Folders and Syncthing Shares

After reboot and login:
- Configure Syncthing folders based on your plan (`/mnt/data/syncthing/...`)
- Use Tailscale to connect from outside your LAN
- Test file syncing from PC/Android
