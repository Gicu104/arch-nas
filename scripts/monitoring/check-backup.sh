today=$(date +%F)
directory="/mnt/data/backup/cloudshare"

if ! ls "$directory" | grep -q "^$today"; then
  echo "[ALERT] Backup missing for $(date +%F)" >> /var/log/alerts/backup-alert.log
fi
