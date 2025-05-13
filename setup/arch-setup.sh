#!/bin/bash
set -e

# Load config
source ./config.conf

# Set hostname
echo "$HOSTNAME" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# Create user if not exists
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists. Skipping creation."
else
    useradd -m -G wheel "$USERNAME"
    echo "Change root password"
    passwd
    echo "Change $USERNAME password"
    passwd "$USERNAME"
fi

# Function to check if a package is installed
is_package_installed() {
    pacman -Q "$1" &>/dev/null
}

# Install essential packages if not already installed
ESSENTIAL_PACKAGES=(
    sudo
    nano
    git
    bash-completion
    man-db
    man-pages
    less
)

for pkg in "${ESSENTIAL_PACKAGES[@]}"; do
    if ! is_package_installed "$pkg"; then
        echo "Installing $pkg..."
        pacman -S --noconfirm "$pkg"
    else
        echo "$pkg is already installed."
    fi
done

# Configure sudo
if [[ "$SETUP_SUDO" == "yes" ]]; then
    echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/99_wheel
    chmod 440 /etc/sudoers.d/99_wheel
fi

# Install network tools if not already installed
if ! is_package_installed "networkmanager"; then
    pacman -S --noconfirm networkmanager
    systemctl enable NetworkManager
fi

# Configure static IP if requested
if [[ "$USE_STATIC_IP" == "yes" ]]; then
    cat > /etc/NetworkManager/system-connections/static.nmconnection <<EOF
[connection]
id=static
type=ethernet
interface-name=$INTERFACE_NAME
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

# Install SSH if not already installed
if ! is_package_installed "openssh"; then
    pacman -S --noconfirm openssh
    systemctl enable sshd
fi
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
# Format and mount HDD if UUID is specified and not yet in fstab
if [[ -n "$HDD_UUID" ]]; then
    # Find device by UUID
    HDD_DEV=$(blkid -U "$HDD_UUID" || true)
    
    if [[ "$SETUP_HDD" == "yes" ]]; then
        # Check if it's already in fstab
        if ! grep -q "$HDD_UUID" /etc/fstab; then
            echo "Formatting $HDD_DEV as ext4..."
            mkfs.ext4 -F "$HDD_DEV"

            echo "Mounting $HDD_DEV to /mnt/data..."
            mkdir -p /mnt/data
            echo "UUID=$HDD_UUID /mnt/data ext4 defaults,noatime 0 2" >> /etc/fstab
            mount /mnt/data
        fi
    else
        echo "Warning: HDD with UUID=$HDD_UUID not found. Skipping HDD setup."
    fi
fi

# Install UFW if not already installed
if [[ "$SETUP_FIREWALL" == "yes" ]] && ! is_package_installed "ufw"; then
    pacman -S --noconfirm ufw
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow OpenSSH
    ufw allow 8384
    ufw enable
fi

# DMA kernel module workaround for reboot issues on Cherry Trail SoCs
echo "Applying DMA blacklist workaround..."

cat > /etc/modprobe.d/blacklist-dma.conf <<EOF
blacklist dw_dmac_core
install dw_dmac /bin/true
install dw_dmac_core /bin/true
EOF

# Rebuild initramfs (use mkinitcpio on Arch)
echo "Regenerating initramfs..."
mkinitcpio -P

echo "Basic system setup completed. Reboot when ready."
