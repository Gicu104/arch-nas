# BIOS Settings for Dell Wyse 3040 NAS

This document captures the recommended BIOS configuration for optimizing the Wyse 3040 as a low-power, headless NAS.

## BIOS Version
- **Version**: 1.2.5 (latest as of Oct 2019)

## General Settings
- **System Time**: Set to local time (ensure sync with Arch NTP post-install)
- **Keyboard Error Detection**: **Disabled** (since the device runs headless)

## Integrated Peripherals
- **Integrated NIC**: **Enabled**
- **PXE Boot**: **Disabled**
- **Audio**: **Disabled**
- **WLAN / Bluetooth**: **Disabled** (saves power, unused in this setup)

## Power Management
- **Auto Power On (AC Recovery)**: **Enabled**  
  Powers the device back on automatically after power loss.

- **Wake-on-LAN (WOL)**: **Enabled**  
  Allows the device to be turned on remotely via network packet.

## Boot
- **Boot Order**: USB first (for installation phase)
- **Secure Boot**: Optional (you can leave default unless boot issues)

## Notes
- Changes aim for low power, high reliability
- Ideal for headless operation and remote management
