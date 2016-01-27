#!/bin/bash
ROOT='/dev/sda1'
MULTILIB_OPT='-nomultilib'
ROOTDIR='/mnt/gentoo/'
DOMAIN='.local'
HOSTNAME='orbit'
mkdir /mnt/gentoo
mount $ROOT /mnt/gentoo
baseurl='http://distfiles.gentoo.org/releases/amd64/autobuilds/'
latest='latest-stage3-amd64'
extension='.txt'
cd /mnt/gentoo
wget $baseurl$latest$MULTILIB_OPT$extension
TEMP1=$(grep -w "^[0-9]\{8\}" $ROOTDIR$latest$MULTILIB_OPT$extension | sed -e 's/ .*$//')
sleep 2
wget $baseurl$TEMP1
wget 'http://distfiles.gentoo.org/releases/snapshots/current/portage-latest.tar.bz2'
sleep 2
tar --numeric-owner --xattrs -xvjpf stage3-*.tar.bz2 -C /mnt/gentoo
tar -xvjf /mnt/gentoo/portage-*.tar.bz2 -C /mnt/gentoo/usr
# Mounting and chrooting
cp -L /etc/resolv.conf /mnt/gentoo/etc/resolv.conf
cp -L localtime /mnt/gentoo/etc/localtime
cp -L make.conf /mnt/gentoo/etc/portage/make.conf
echo $HOSTNAME$DOMAIN >> /mnt/gentoo/etc/resolv.conf
echo 'de_DE ISO-8859-1' > /mnt/gentoo/etc/locale.gen
echo 'de_DE@euro ISO-8859-15' >> /mnt/gentoo/etc/locale.gen
#echo "app-emulation/virtualbox-guest-additions ~x86" >> /mnt/gentoo/etc/portage/package.accept_keywords
#echo "x11-drivers/xf86-video-virtualbox ~x86" >> /mnt/gentoo/etc/portage/package.accept_keywords
#echo "x11-drivers/xf86-input-virtualbox ~x86" >> /mnt/gentoo/etc/portage/package.accept_keywords
mount -o bind /proc /mnt/gentoo/proc
mount --rbind /dev /mnt/gentoo/dev
# Build chroot commands
echo "" > install_gentoo.sh
#kernel sources
#echo "emerge gentoo-sources vanilla-sources" >> install_gentoo.sh
#wifi using broadcom-sta
#echo "emerge broadcom-sta wicd wpa_supplicant" >> install_gentoo.sh
#laptop stuff
#echo "emerge mtrack alsautils mplayer mpg123" >> install_gentoo.sh
# Add unprivileged users to vboxguest group. This will allow automatic resize and seamless mode:
#mv /etc/X11/xorg.conf /etc/X11/xorg.conf.bak
#gpasswd -a <user> vboxguest
echo "emerge gentoo-sources" >> install_gentoo.sh
echo "emerge --update --deep --newuse world" >> install_gentoo.sh
echo "emerge virtualbox-guest-additions" >> install_gentoo.sh
#echo "emerge xf86-input-virtualbox xf86-video-virtualbox" >> install_gentoo.sh
echo "rc-update add virtualbox-guest-additions default" >> install_gentoo.sh
echo "/etc/init.d/virtualbox-guest-additions start" >> install_gentoo.sh
echo "emerge pciutils usbutils hwids lshw links opensshd terminus-font diskdev_cmds lsof open-iscsi iscsi-target xz-utils ddrescue icedtea-web" >> install_gentoo.sh
echo "rc-update add sshd default" >> install_gentoo.sh
echo "cd /usr/src/linux" >> install_gentoo.sh
cp install_gentoo.sh /mnt/gentoo/
chmod +x /mnt/gentoo/install_gentoo.sh
chroot /mnt/gentoo /bin/bash install_gentoo.sh