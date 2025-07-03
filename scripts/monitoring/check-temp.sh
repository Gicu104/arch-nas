#!/bin/bash
TEMP_THRESHOLD=70

sensors | grep -E 'Core|temp1' | while read -r line; do
  TEMP=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+' | head -1)
  if (( $(echo "$TEMP > $TEMP_THRESHOLD" | bc -l) )); then
    echo "[ALERT] High temp ($TEMP°C): $line at $(date)" >> /var/log/alerts/temp-alert.log
  fi
done
