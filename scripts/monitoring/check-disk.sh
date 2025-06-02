#!/bin/bash
THRESHOLD=90
USAGE=$(df /mnt/data | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$USAGE" -ge "$THRESHOLD" ]; then
  echo "[ALERT] /mnt/data disk usage is at ${USAGE}% as of $(date)" >> /var/log/disk-alert.log
fi
