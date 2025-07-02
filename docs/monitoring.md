# Monitoring

This repository provides a basic but extensible monitoring setup for your Arch Linux NAS, using familiar Linux tools and automated scripts. The monitoring solution is managed by the `scripts/create-monitoring-units.sh` script, which sets up required packages, monitoring scripts, and cron jobs.

## Overview

Monitoring is accomplished by:

1. Installing required monitoring tools and utilities.
2. Creating monitoring script stubs (if not present).
3. Setting up cron jobs to run health-check scripts at regular intervals.

## Tools Used

- **htop**: Process monitoring
- **systemctl**: Service status checks
- **lm_sensors**: Hardware temperature and sensor monitoring
- **vnstat**: Network bandwidth monitoring
- **bmon**: Real-time bandwidth monitor
- **cronie**: Cron daemon for scheduled tasks
- **smartmontools**: Disk health (S.M.A.R.T.) monitoring
- **coreutils, bc**: Essential shell utilities

## Setup: `create-monitoring-units.sh`

The `scripts/create-monitoring-units.sh` script automates the following steps:

### 1. Install Required Packages

The script checks for and installs any missing packages from the list above, using `pacman`. It also enables `vnstat` and runs `sensors-detect` to set up hardware sensors.

### 2. Monitoring Script Stubs

It defines a set of health-check scripts in `/arch-nas/scripts/monitoring`:

- check-backup.sh
- check-disk.sh
- check-bandwidth.sh
- check-syncthing.sh
- check-temp.sh

If a script does not exist, the script creates a stub for it.

### 3. Cron Job Scheduling

Each check is scheduled via cron at an appropriate interval:

| Script           | Interval  | Cron Schedule         | Purpose                     |
|------------------|-----------|-----------------------|-----------------------------|
| check-backup     | at 4am    | 0 4 * * *            | Runs daily at 4am           |
| check-disk       | every 2h  | 0 */2 * * *          | Every 2 hours               |
| check-bandwidth  | daily     | 0 2 * * *            | Daily at 2am                |
| check-syncthing  | 10 min    | */10 * * * *         | Every 10 minutes            |
| check-temp       | 30 min    | */30 * * * *         | Every 30 minutes            |

These cron jobs will execute the health-check scripts as root.

Any previous duplicate cron entries are removed automatically.

### 4. Logging & Alerts

You can monitor for alerts from health-check scripts by adding the following snippet to your `~/.bash_profile` or `~/.bashrc` to display the latest alerts at login:

```bash
for LOG in /var/log/*-alert.log; do
  [ -s "$LOG" ] && echo "=== ALERTS from $(basename $LOG) ===" && tail -n 3 "$LOG"
done
```
## Usage
1. Make `scripts/create-monitoring-units.sh` executable:
```sh
chmod +x scripts/create-monitoring-units.sh
```
2. Run the script (as root or with sudo):
```sh
sudo ./scripts/create-monitoring-units.sh
```
3. (Optional) Add the alert display snippet to your shell profile for prompt alerts.
```sh
sudo nano .bashrc
```
Add this at the end of file:
```bash
for LOG in /var/log/*-alert.log; do
  [ -s "$LOG" ] && echo "=== ALERTS from $(basename $LOG) ===" && tail -n 3 "$LOG"
done
```

## Extending Monitoring
- Add additional health-check scripts to /arch-nas/scripts/monitoring and their schedules to the CHECKS array in create-monitoring-units.sh as needed.
- Each script can log alerts to /var/log/*-alert.log for display at login.
- Future plans may include upgrading to advanced stacks like Prometheus + Grafana.
