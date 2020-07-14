#!/bin/bash
#formatting drive in fdisk
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
g
n


+512M
t
1
n
2


w
q
EOF
#
#properly format main drive
mkfs.ext4 /dev/sda2
#properly format efi
mkfs.fat -F 32 /dev/sda1
#mount boot drive
mount /dev/sda2 /mnt
echo "Server = http://mirrors.gigenet.com/archlinux/$repo/os/$arch" > /etc/pacman.d/mirrorlist
#install pacstrap
pacstrap /mnt base linux linux-firmware nano sudo
#genfstab
genfstab -U /mnt >> /mnt/etc/fstab
#chroot
arch-chroot /mnt /bin/bash
sed -i "/#en_US.UTF-8/s/^#//g" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
hwclock --systohc --localtime
echo archpc >> /etc/hostname
#update hosts file
echo -e "127.0.0.1 \tlocalhost\n::1 \t\tlocalhost\n127.0.1.1 \tarchpc" >> /etc/hosts
#echo 127.0.0.1 localhost ::1 localhost 127.0.1.1 host >> /etc/hosts
#update pacman
pacman -Syu --noconfirm
#network manager
pacman -S networkmanager --noconfirm
systemctl enable NetworkManager.service
#mkinitcpio
mkinitcpio -P
echo "User password"
useradd -m -G wheel,users -s /bin/bash john
passwd john
echo "Root password"
passwd

visudo
