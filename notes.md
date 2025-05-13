# Notes workspace
Here I will write all notes which may be helpfull during/after installation/configuration

## instalation
```
loadkeys pl
```
check internet connection 

```
timedatectl set-ntp true
```
updated uuid 
```
lsblk
```
hdd sdb
os flash mmcblk0
make partitions
```
cfdisk /dev/mmcblk0
```
gpt if prompted

set [type]

Linux efi system	~512MB–1GB	(swap)	efi	Optional if low RAM, this is mmcblk0p1

Linux swap	      ~512MB–1GB	(swap)	swap	Optional if low RAM, this is mmcblk0p2

Linux filesystem	rest of disk	/	root / 64	Main root partition, this is mmcblk0p3

### [WRITE] after everything done before leaving cfdisk

and
```
cfdisk /dev/sdb
```
```
partprobe /dev/mmcblk0
mkfs.fat /dev/mmcblk0p1
mkfs.ext4 /dev/mmcblk0p3
mkswap /dev/mmcblk0p2
mount /dev/mmcblk0p3 /mnt
mount --mkdir /dev/mmcblk0p1 /mnt/boot
swapon /dev/mmcblk0p2
```
### now important
```
pacstrap /mnt base linux linux-firmware sudo networkmanager
```
```
arch-chroot /mnt
```

downlload install script if public or token in hand
```
pacman -Sy git
git clone https://github.com/Gicu104/arch-nas.git /mnt/root/arch-nas
cd /mnt/root/arch-nas/setup/
bash arch-setup.sh config.conf
```
```
exit
umount -R /mnt
```
grub was correct
```
reboot
```
### New instalation
 I reinstalled it for sake

Boot from liveiso
check internet connection 
```
loadkeys pl
timedatectl set-ntp true
lsblk
```
look for your flash disk, propably mmcblk0
```
cfdisk /dev/mmcblk0
```
- wipe everything and make 3 partitions
- 512M [TYPE] EFI system
- 512M [TYPE] Linux swap
- rest [TYPE] Linux root (x86-64)
- [WRITE] 'yes' to save changes
- [QUIT]

format partitions
```
partprobe /dev/mmcblk0
mkfs.fat /dev/mmcblk0p1
mkswap /dev/mmcblk0p2
mkfs.ext4 /dev/mmcblk0p3
```
mount partitions
```
swapon /dev/mmcblk0p2
mount /dev/mmcblk0p3 /mnt
mount --mkdir /dev/mmcblk0p1 /mnt/boot
```
now you can check lsblk
```
pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```
now you are in your system, change password and install bootloader
```
passwd
```
if boot not mounted 
```
mount /dev/mmcblk0p1 /boot
```
```
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
mkdir -p /boot/EFI/BOOT
cp /boot/EFI/GRUB/grubx64.efi /boot/EFI/BOOT/BOOTX64.EFI
efibootmgr --create --disk /dev/mmcblk0 --part 1 --label "ArchLinux" --loader /EFI/GRUB/grubx64.efi
exit
```
```
umount -R /mnt
```
pray for best
```
reboot
```


# After initial install
upgrade
```
pacman -Sy
```

reboot issues

boot=acpi, pci, force, hard doesnt work
try this
```
sudo nano /etc/modprobe.d/blacklist-dma.conf
```
```
blacklist dw_dmac_core
install dw_dmac /bin/true
install dw_dmac_core /bin/true
```
```
sudo mkinitcpio -P
```
```
sudo shutdown -r now
```
this should repair wyse behavior
https://github.com/up-board/up-community/wiki/Ubuntu_20.04#hang-on-shutdown-or-reboot-for-up-board
