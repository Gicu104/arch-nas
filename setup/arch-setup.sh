#!/bin/bash
set -e

# Load config
source ./config.conf

# Set hostname
echo "$HOSTNAME" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# Create user
useradd -m -G wheel "$USERNAME"
passwd "$USERNAME"

# Configure sudo
if [[ "$SETUP_SUDO" == "yes" ]]; then
    pacman -S --noconfirm sudo
    echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/99_wheel
    chmod 440 /etc/sudoers.d/99_wheel
fi

# Install network tools
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager

# Configure static IP if requested
if [[ "$USE_STATIC_IP" == "yes" ]]; then
    cat > /etc/NetworkManager/system-connections/static.nmconnection <<EOF
[connection]
id=static
type=ethernet
interface-name=eth0
autoconnect=true

[ipv4]
method=manual
addresses=${STATIC_IP}/${SUBNET_MASK}
gateway=${GATEWAY}
dns=${DNS};
ignore-auto-dns=true

[ipv6]
method=ignore
EOF
    chmod 600 /etc/NetworkManager/system-connections/static.nmconnection
fi

# Set up SSH
pacman -S --noconfirm openssh
systemctl enable sshd
if [[ "$DISABLE_ROOT_SSH" == "yes" ]]; then
    sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
fi
if [[ -f "$SSH_KEY_PATH" ]]; then
    mkdir -p "/home/$USERNAME/.ssh"
    cp "$SSH_KEY_PATH" "/home/$USERNAME/.ssh/authorized_keys"
    chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"
    chmod 700 "/home/$USERNAME/.ssh"
    chmod 600 "/home/$USERNAME/.ssh/authorized_keys"
fi

# Set up mount point (UUID must be filled in later)
if [[ -n "$HDD_UUID" ]]; then
    mkdir -p /mnt/data
    echo "UUID=$HDD_UUID /mnt/data ext4 defaults,noatime 0 2" >> /etc/fstab
fi

echo "Basic system setup completed. Reboot when ready."
