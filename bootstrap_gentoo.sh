#!/bin/bash
ROOT='/dev/sda1'
MULTILIB_OPT='-nomultilib'
ROOTDIR='/mnt/gentoo/'
mkdir /mnt/gentoo
mount $ROOT /mnt/gentoo
baseurl='http://distfiles.gentoo.org/releases/amd64/autobuilds/'
latest='latest-stage3-amd64'
extension='.txt'
cd /mnt/gentoo
wget $baseurl$latest$MULTILIB_OPT$extension
temp = $(grep -w "^[0-9]\{8\}" $ROOTDIR$latest$MULTILIB_OPT$extension | sed -e 's/ .*$//')
wget $baseurl$temp
tar --numeric-owner --xattrs -xvjpf stage3-*.tar.bz2 -C /mnt/gentoo
# Mounting and chrooting
cp -L /etc/resolv.conf /mnt/gentoo/etc/resolv.conf
mount -o bind /proc /mnt/gentoo/proc
mount --rbind /dev /mnt/gentoo/dev
# Build chroot commands
echo "" >> install_gentoo.sh
echo "" >> install_gentoo.sh
cp install_gentoo.sh /mnt/gentoo/
chmod +x /mnt/gentoo/install_gentoo.sh
chroot /mnt/gentoo /bin/bash install_gentoo.sh