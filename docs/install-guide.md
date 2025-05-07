# Arch Linux NAS Installation Guide

This guide walks you through installing and configuring your Arch-based NAS on the Dell Wyse 3040, using both manual steps and an automated setup script.

---

## Prerequisites

- Dell Wyse 3040 with at least 2GB of RAM
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

### Step 2: Prepare the Internal Storage

Partition and format the internal drive (e.g., eMMC or SSD). Mount the root partition at `/mnt`.

You can use tools like `cfdisk` or `parted` to manually partition the disk.

### Step 3: Transfer Setup Files

Clone this repository or copy the setup files to the target system:
```
git clone https://github.com/Gicu104/arch-nas.git
cd arch-nas/setup/
```

Or use a USB stick or `scp` if you prefer.

### Step 4: Run the script

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

### Step 5: Reboot and SSH in

Once done, reboot the machine and connect to it via SSH using the static IP defined in `config.conf`.
```
reboot
```

## Notes for script

- TThe script aims to be idempotent where possible, but use with care.
- Safe for repeated usage only if you're aware of its effects.
- `config.conf` should **never** be committed with passwords or private keys.
- All sensitive tasks (disk formatting, password setup, etc.) should be done manually for now.

## Step 6: Install Syncthing nad Tailscale
```
sudo pacman -S syncthing
sudo systemctl enable syncthing
```

Follow Tailscale's installation guide for Arch Linux.

Access Syncthing via the web UI (http://localhost:8384) and add your folders.

## Step 7: Configure Folders and Syncthing Shares

After reboot and login:
- Configure Syncthing folders based on your plan (`/mnt/data/syncthing/...`)
- Use Tailscale to connect from outside your LAN
- Test file syncing from PC/Android

## License

MIT — use and modify freely, just don't blame the author if it burns your house down.