#!/bin/bash
set -e

# === 1. Ensure required packages are installed ===
echo "[+] Checking required packages..."
PKGS=(bc coreutils systemd htop lm_sensors vnstat bmon cronie smartmontools)
for pkg in "${PKGS[@]}"; do
    if ! pacman -Q $pkg &>/dev/null; then
        echo "[+] Installing missing package: $pkg"
        sudo pacman -Sy --noconfirm $pkg
    fi
done
sudo systemctl enable --now vnstat
sudo sensors-detect

# === 2. Configuration: Define checks and intervals here ===
CHECKS=(
  "check-backup:at5"
  "check-disk:2h"
  "check-bandwidth:1d"
  "check-syncthing:10min"
  "check-temp:30min"
)

SCRIPTS_DIR="/arch-nas/scripts/monitoring"

# Helper: convert interval string to cron schedule
interval_to_cron() {
    local interval="$1"
    case "$interval" in
        1d) echo "0 2 * * *" ;;        # daily at 2am
        2h) echo "0 */2 * * *" ;;      # every 2 hours
        1h) echo "0 * * * *" ;;        # every hour
        10min) echo "*/10 * * * *" ;;  # every 10 minutes
        30min) echo "*/30 * * * *" ;;  # every 30 minutes
        at5) echo "0 5 * * *" ;;  # daily at 5 am
        *) echo "0 3 * * *" ;;         # fallback: daily at 3am
    esac
}

echo "[+] Creating script stubs and cron jobs..."

TMP_CRON="$(mktemp)"
sudo crontab -l > "$TMP_CRON" 2>/dev/null || true

for entry in "${CHECKS[@]}"; do
    NAME="${entry%%:*}"
    INTERVAL="${entry##*:}"
    SCRIPT_PATH="$SCRIPTS_DIR/$NAME.sh"

    # Create stub if missing
    if [ ! -f "$SCRIPT_PATH" ]; then
        sudo tee "$SCRIPT_PATH" > /dev/null <<EOF
#!/bin/bash
echo "[$(date)] $NAME executed"
EOF
        sudo chmod +x "$SCRIPT_PATH"
    fi

    CRON_SCHEDULE=$(interval_to_cron "$INTERVAL")

    # Remove previous duplicate cron jobs
    sed -i "\|$SCRIPT_PATH|d" "$TMP_CRON"

    # Add new cron job
    echo "$CRON_SCHEDULE $SCRIPT_PATH" | sudo tee -a "$TMP_CRON" > /dev/null

    echo "[✓] Cron job for $NAME ($INTERVAL): $CRON_SCHEDULE"
done

sudo crontab "$TMP_CRON"
rm "$TMP_CRON"

echo "[✓] All monitoring cron jobs deployed and running."
