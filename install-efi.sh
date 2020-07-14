#!/bin/bash
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/nvme0n1
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
mkfs.ext4 /dev/nvme0n1p2
#properly format efi
mkfs.fat -F 32 /dev/nvme0n1p1
#mount boot drive
mount /dev/nvme0n1p2 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p3 /mnt/boot
echo "Server = http://mirrors.gigenet.com/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
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
hwclock --systohc --utc
timedatectl set-ntp true
echo archpc >> /etc/hostname
sed -i "/#%wheel/s/^#//g" /etc/sudoers
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

echo "kohl4072" | passwd --stdin
useradd -m -G wheel,users -s /bin/bash john
echo "kohl4072" | passwd --stdin john

fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab

bootctl install
curl -o- https://raw.githubusercontent.com/jmayniac/Arch-Installer/master/arch.conf > /boot/
