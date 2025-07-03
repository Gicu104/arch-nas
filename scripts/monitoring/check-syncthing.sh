#!/bin/bash
if ! systemctl is-active --quiet syncthing@gicu; then
    echo "Syncthing is down at $(date)" >> /var/log/alerts/syncthing-alert.log
fi
