# arch-nas  
Personal Arch Linux NAS + Syncthing Homelab

## Arch Linux Homelab

Welcome to my personal NAS / cloud-replacement homelab powered by Arch Linux, Dell Wyse 3040, Syncthing, and Tailscale.

This project is meant to replace cloud services like OneDrive or Google One by using your own low-power device and open-source tools. The entire configuration is documented and scriptable.

---

## Goals

- Replace OneDrive / Google One with private storage
- Automatic phone + PC file sync
- Secure access from anywhere using Tailscale
- Headless operation (no monitor/keyboard after setup)
- Scripted and reproducible install
- Minimal power usage (Dell Wyse 3040 + USB HDD)

---

## Stack

- **Arch Linux** (minimal CLI-based setup)
- **Syncthing** (device-to-device sync)
- **Tailscale** (remote access over WireGuard)
- **EXT4** filesystem on external USB HDD
- **Git**-tracked configs and scripts

---

## Project Structure

- `setup/`
  - `arch-setup.sh`: Main install + config script
  - `config.conf`: Defines hostname, user, IP settings, etc.
- `docs/`
  - `install-guide.md`: Full setup walkthrough
  - `disk-layout.md`: Drive structure and mountpoints
  - `backup-strategy.md`: Backup plan and destinations
  - `monitoring.md`: Monitoring tools and logging
  - `bios-settings.md`: BIOS configuration reference
- `TODO.md`: Tasks and future plans

---

## Documentation

- **[Install Guide](docs/install-guide.md)** - Install Arch Linux and bootstrap NAS config
- **[Disk Layout](docs/disk-layout.md)** - Mountpoints and storage scheme
- **[Backup Strategy](docs/backup-strategy.md)** - What and how we back up
- **[Monitoring](docs/monitoring.md)** - Watch your system's health
- **[BIOS Settings](docs/bios-settings.md)** - What to tweak in Wyse BIOS

---

## Status

This project is in version **1.0** - installation is tested and working, documentation ongoing.

Planned next steps:
- More robust backup strategies
- RAID or mirroring options
- Battery backup integration
- Mobile UI shortcuts

---

##  Disclaimer

This setup is designed for personal use. You're welcome to copy, modify, or fork - but do your own testing. I take no responsibility if it bricks your toaster.

---

## License

Arch-NAS
Copyright (C) {{ 2025 }}  {{ Gicu }}

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
