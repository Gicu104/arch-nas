#!/bin/bash
set -e

# === 1. Ensure required packages are installed ===
echo "[+] Checking required packages..."
PKGS=(bc coreutils systemd)
for pkg in "${PKGS[@]}"; do
    if ! pacman -Q $pkg &>/dev/null; then
        echo "[+] Installing missing package: $pkg"
        sudo pacman -Sy --noconfirm $pkg
    fi
done

# === 2. Configuration: Define checks and intervals here ===
CHECKS=(
  "check-backup:1d"
  "check-disk:2h"
  "check-bandwidth:1d"
  "check-syncthing:10min"
  "check-temp:30min"
)

TARGET_DIR="/etc/systemd/system"

for entry in "${CHECKS[@]}"; do
    NAME="${entry%%:*}"
    INTERVAL="${entry##*:}"
    SCRIPT_PATH="/arch-nas/scripts/monitoring/$NAME.sh"

    echo "[+] Creating files for $NAME (interval: $INTERVAL)"

    # === Service ===
    sudo tee "$TARGET_DIR/$NAME.service" > /dev/null <<EOF
[Unit]
Description=$NAME monitoring task

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
EOF

    # === Timer ===
    sudo tee "$TARGET_DIR/$NAME.timer" > /dev/null <<EOF
[Unit]
Description=Timer for $NAME

[Timer]
OnBootSec=5min
OnUnitActiveSec=$INTERVAL
Persistent=true

[Install]
WantedBy=timers.target
EOF

    # === Script Stub ===
    if [ ! -f "$SCRIPT_PATH" ]; then
      sudo tee "$SCRIPT_PATH" > /dev/null <<EOF
#!/bin/bash
echo "[$(date)] $NAME executed"
EOF
      sudo chmod +x "$SCRIPT_PATH"
    fi

    echo "[✓] Created $NAME.{service,timer}, script stub at $SCRIPT_PATH"
done

echo "[+] Enabling and starting timers..."
for entry in "${CHECKS[@]}"; do
    NAME="${entry%%:*}"
    sudo systemctl daemon-reexec
    sudo systemctl daemon-reload
    sudo systemctl enable --now "$NAME.timer"
done

echo "[✓] All monitoring units deployed and running."
