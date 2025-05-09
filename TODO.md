# TODO List for Arch NAS Setup

## High Priority:

### Complete Arch Linux Installation
- [ ] Install Arch on Wyse 3040
- [ ] Configure static IP
- [ ] Setup SSH and key-based authentication
- [ ] Enable networking & firewall rules

### Configure and Run Setup Script
- [ ] Test `arch-setup.sh` for proper execution
- [ ] Check all configuration paths in `config.conf`
- [ ] Validate user creation and sudo setup
- [ ] Confirm automatic reboot after installation

### Install Syncthing
- [ ] Install Syncthing and test functionality
- [ ] Configure Syncthing with the necessary shared folders
- [ ] Set up Syncthing’s web UI and verify sync operation

### Set Up Tailscale for Remote Access
- [ ] Install Tailscale on Wyse
- [ ] Configure Tailscale for remote access
- [ ] Test connectivity with devices outside local network

## Medium Priority:

### System Backup Strategy
- [ ] Set up backup locations on external HDD
- [ ] Automate backups of Syncthing folders
- [ ] Write backup script for critical data (perhaps rsync)

### Testing and Monitoring
- [ ] Install basic monitoring tools (e.g., `htop`, `smartmontools`)
- [ ] Set up a system for checking disk health and performance
- [ ] Review server logs for errors

### Documenting the Build
- [ ] Refine `README.md` with all final details
- [ ] Finalize `install-guide.md`
- [ ] Ensure `backup-strategy.md` is complete and clear
- [ ] Polish `monitoring.md` with useful tips

## Low Priority:

### Network Optimization
- [ ] Test network speed and stability
- [ ] Optimize network configurations (if needed)

### Hardware Upgrades
- [ ] Check if the Wyse 3040 supports additional RAM
- [ ] Consider adding more storage or upgrading existing HDD

### Long-term Improvements
- [ ] Setup RAID configuration if needed
- [ ] Plan future upgrades for the system or expand capacity
- [ ] Add funcionality to make notes remotely