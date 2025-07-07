#!/bin/bash
set -e

# Load config
source ./config.conf

# 1. System setup (run as root)
bash ./scripts/01-system-setup.sh

# 2. Clone repo to user home, remove from root if exists
if [ ! -d "/home/$USERNAME/arch-nas" ]; then
    sudo -u "$USERNAME" git clone https://github.com/Gicu104/arch-nas "/home/$USERNAME/arch-nas"
fi

# 3. Syncthing, Tailscale, backup, etc. (run as user)
sudo -u "$USERNAME" bash ./scripts/02-syncthing-setup.sh

# 4. Git setup and package list (run as user)
sudo -u "$USERNAME" bash ./scripts/03-git-setup.sh

# 5. Monitoring units (run as user)
sudo -u "$USERNAME" bash ./scripts/create-monitoring-units.sh

if [ -d "/root/arch-nas" ]; then
    rm -rf /root/arch-nas
fi

echo "All setup scripts completed. Reboot when ready."
