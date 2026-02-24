#/bin/bash

#----------------------------#
# take base steps from https://wiki.archlinux.org/title/Installation_guide
timedatectl
fdisk -l
fdisk /dev/<the_disk_to_be_partitioned>
#create partitions /boot and /
mkfs.ext4 /dev/<root_partition>
mkfs.fat -F 32 /dev/<efi_system_partition>
mount /dev/<root_partition> /mnt
mount --mkdir /dev/<efi_system_partition> /mnt/boot

pacstrap /mnt base linux linux-firmware vim base-devel
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Area/Location /etc/localtime
hwclock --systohc

#uncomment next
#en_US.UTF-8
#ru_RU.UTF-8
vim /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "home" > /etc/hostname
mkinitcpio -P
passwd

#----------------------------#
# now grub Installation
pacman -S grub efibootmgr

#for UEFI loaders
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
efibootmgr -v

#----------------------------#
# stop with ISO reboot next
exit
umount -R /mnt
reboot

#----------------------------#
# first customisation
useradd -m -G wheel -s /bin/bash <yourusername>
pacman -S sudo

#sync time if needed
sudo timedatectl set-ntp true

#uncomment this in visudo %wheel ALL=(ALL) ALL
EDITOR=vim visudo
pacman -Syu

#----------------------------#
# internet connection (for first time if isn't working), without wifi packages
systemctl enable systemd-networkd
systemctl start systemd-networkd

systemctl enable systemd-resolved
systemctl start systemd-resolved
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

#take this in file (no #)
#[Match]
#Name=eno1

#[Network]
#DHCP=yes
vim /etc/systemd/network/20-wired.network

systemctl restart systemd-networkd
systemctl restart systemd-resolved

#if works, replace woth network-manager
pacman -S networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager
nmcli device status

systemctl disable systemd-networkd
systemctl stop systemd-networkd

#----------------------------#
#now X server
pacman -S xorg-server xorg-xinit xorg-xrandr
#now nvidia drivers
pacman -S nvidia-open nvidia-utils nvidia-settings
mkinitcpio -P
reboot
#test driver
nvidia-smi

#----------------------------#
#audio dirvers now
sudo pacman -S pulsemixer pipewire pipewire-pulse pipewire-alsa wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
#check with
pactl info



