# Installation Guide

This guide will walk you through installing and configuring your Arch-based NAS.

## Prerequisites
- Dell Wyse 3040 with at least 2GB of RAM
- External HDD (1TB+) for storage
- A working internet connection

## Step 1: Install Arch Linux
Follow the official Arch Installation guide: https://wiki.archlinux.org/title/Installation_guide

### Key Points:
- Use **minimal installation** to start with
- Set up partitions manually with `cfdisk` or `parted`
- Set up a **swap partition** if needed
- Set hostname and configure `/etc/hosts`

## Step 2: Install Packages
sudo pacman -Syu
sudo pacman -S git curl nano

##Step 3: Configure Networking
Install and configure dhcpcd or NetworkManager for networking.
sudo pacman -S networkmanager
sudo systemctl enable NetworkManager

##OPTIONAL - Going Headless (No Monitor/Keyboard Needed)
Once the following steps are complete, you can safely unplug the monitor and keyboard and manage your Wyse server entirely over SSH:
Arch Linux is installed
Base system + bootloader
Non-root user created
Networking is functional
Internet access confirmed via ping
DHCP or static IP assigned
SSH is set up and running

sudo pacman -S openssh
sudo systemctl enable sshd
sudo systemctl start sshd

SSH access from another device is confirmed

From your PC: ssh your-user@<wyse-ip>
Once confirmed, you can:
Disconnect monitor and keyboard
Manage the Wyse via SSH
Proceed with full headless configuration

##Step 4: Install Syncthing
sudo pacman -S syncthing
sudo systemctl enable syncthing

##Step 5: Set up Syncthing
Access Syncthing via the web UI (http://localhost:8384) and add your folders.

##Step 6: Install Tailscale
Follow Tailscale's installation guide for Arch Linux.

###Test the Setup
After completing the setup, you should be able to access Syncthing from any of your devices using Tailscale for remote access.