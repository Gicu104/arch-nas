# Monitoring

For now, monitoring will be done through basic tools, but the goal is to move to a more advanced monitoring stack.

## Tools
1. **htop** - for process monitoring
2. **systemctl** - for checking service statuses

## Alerts
- Use **systemd timers** to automate checking logs or processes.
- Set up basic email alerts (later on, possibly Prometheus + Grafana).

### Check system health:
htop
systemctl status syncthing
---
# Installation (service status for now)
```
sudo pacman -S htop lm_sensors vnstat bmon cronie smartmontools bc
sudo systemctl enable --now vnstat
sudo sensors-detect  # run and accept recommended
```
script from git
```
#!/bin/bash
if ! systemctl is-active --quiet syncthing@gicu; then
    echo "Syncthing is down at $(date)" >> /var/log/syncthing-alert.log
fi
```
Make it executable:
```
sudo chmod +x /arch-nas/scripts/check-syncthing.sh
```
Create systemd timer + service:
`/etc/systemd/system/check-syncthing.service`
```
[Unit]
Description=Check Syncthing Health

[Service]
Type=oneshot
ExecStart=/arch-nas/scripts/check-syncthing.sh
```
`/etc/systemd/system/check-syncthing.timer`
```
[Unit]
Description=Timer for Syncthing Health Check

[Timer]
OnBootSec=5min
OnUnitActiveSec=10min

[Install]
WantedBy=timers.target
```
enable timer 
```
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now check-syncthing.timer
```
Put in `.bash_profile` or `.bashrc`:
```
for LOG in /var/log/*-alert.log; do
  [ -s "$LOG" ] && echo "=== ALERTS from $(basename $LOG) ===" && tail -n 3 "$LOG"
done
```
