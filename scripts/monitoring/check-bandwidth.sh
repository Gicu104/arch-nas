#!/bin/bash
# Check if daily RX+TX > threshold (e.g., 3 GB)
THRESHOLD_MB=3000
INTERFACE="enp1s0"  # or check `vnstat --iflist`

TOTAL_MB=$(vnstat --oneline -i $INTERFACE | awk -F\; '{print $(NF-3) + $(NF-1)}')

if (( $(echo "$TOTAL_MB > $THRESHOLD_MB" | bc -l) )); then
  echo "[ALERT] Bandwidth usage high: ${TOTAL_MB}MB used on $(date)" >> /var/log/bandwidth-alert.log
fi
