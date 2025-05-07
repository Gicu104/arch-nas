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

Linux swap	~512MB–1GB	(swap)	swap	Optional if low RAM, this is mmcblk0p1
Linux root	rest of disk	/	ext4	Main root partition, this is mmcblk0p2

### [WRITE] after everything done before leaving cfdisk

and
```
cfdisk /dev/sdb
```
```
mkfs.ext4 /dev/mmcblk0p2
mkswap /dev/mmcblk0p1 && swapon /dev/mmcblk0p1

```
```
mount /dev/mmcblk0p2 /mnt
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
```
reboot
```
## post install sanity check
