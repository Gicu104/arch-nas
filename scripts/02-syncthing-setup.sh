#!/bin/bash
set -e

dirname=$(dirname "$0")
source "$dirname/../config.conf"

# Install Syncthing and Tailscale
pacman -S --noconfirm syncthing tailscale
systemctl enable --now syncthing@"$USERNAME"
systemctl enable --now tailscaled

# Syncthing config update
CONFIG_PATH="/home/$USERNAME/.local/state/syncthing/config.xml"
if [[ -f "$CONFIG_PATH" && $SETUP_SYNC ]]; then
  echo "[*] Found Syncthing config, updating GUI address binding..."
  sed -i 's|<address>127\\.0\\.0.1:8384</address>|<address>0.0.0.0:8384</address>|' "$CONFIG_PATH"
  echo "[+] Address binding updated in config.xml"
  systemctl restart syncthing@$USERNAME
else
  echo "[!] Syncthing config not found at $CONFIG_PATH"
fi

if [[ "$SETUP_SYNC" == "yes" ]]; then
  echo "Provide password 3 times"
  mkdir -p /mnt/data/syncthing
  chown -R $USERNAME:$USERNAME /mnt/data/syncthing
  mkdir -p /mnt/data/syncthing/{phone_android,phone_ios,cloudshare,mediavault}
  chown -R $USERNAME:$USERNAME /mnt/data/syncthing
  mkdir -p /mnt/data/syncthing/phone_android/nothing-phone-3a/{Alarms,DCIM,Documents,Download,Movies,Music,Notifications,Pictures,Ringtones}
  echo "?? Folder structure created and permissions set."
fi

# Configure backups
systemctl enable --now cronie

# Set nano as default editor
export EDITOR=nano
echo 'export EDITOR=nano' >> /home/$USERNAME/.bashrc
echo 'export EDITOR=nano' >> /home/$USERNAME/.bash_profile
echo 'export EDITOR=nano' >> /home/$USERNAME/.profile

chmod +x /home/$USERNAME/arch-nas/scripts/rsync-backup.sh
(crontab -l 2>/dev/null; echo "0 1 * * * /home/$USERNAME/arch-nas/scripts/rsync-backup.sh >> /var/log/backup/rsync-backup.log 2>&1") | crontab -
