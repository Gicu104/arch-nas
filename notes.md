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
and
```
cfdisk /dev/sdb
```
```
mkfs.ext4 /dev/mmcblk0p1
```
```
mount /dev/mmcblk0 /mnt
```
downlload install script if public or token in hand
```
pacman -Sy git
git clone https://github.com/Gicu104/arch-nas.git
cd arch-nas/setup/
bash arch-setup.sh config.conf
```
