#!/bin/bash

# Script: check-for-updates
# Description: Update Arch Linux system and installed packages, then clean up.

set -e

echo "[$(date)] Starting system update..."

# Update package database and upgrade system packages
sudo pacman -Syu --noconfirm

# Remove unused packages and clean cache
sudo pacman -Rns $(pacman -Qdtq) --noconfirm 2>/dev/null || true
sudo pacman -Sc --noconfirm

echo "[$(date)] Update complete."
