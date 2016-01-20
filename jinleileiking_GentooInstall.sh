fdisk /dev/sda


# n
# 1
# +32M
# n
# 2
# +512M
# n
# 3
# t
# 2


echo -e "\e[1;91mMaking File systems..."
mkfs.ext2 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2

echo -e "\e[1;91mPrepare change root..."
echo -e "\e[0m"
mkdir /mnt/gentoo
mount /dev/sda3 /mnt/gentoo
mkdir /mnt/gentoo/boot
mount /dev/sda1 /mnt/gentoo/boot

echo -e "\e[1;91mCopy stage & portage to hadrdisk..MODIFY!!!!..."


#######################################
sudo cp /media/843B-F976/* /mnt/gentoo/
######################################

mkdir /mnt/win
mount -t vboxsf D_DRIVE /mnt/win

cd /mnt/gentoo
tar xvjpf stage3-*.tar.bz2
tar xvjf /mnt/gentoo/portage-*.tar.bz2 -C /mnt/gentoo/usr

echo -e "\e[1;91mChange Root....."

cp -L /etc/resolv.conf /mnt/gentoo/etc/
mount -t proc none /mnt/gentoo/proc
mount --rbind /dev /mnt/gentoo/dev
chroot /mnt/gentoo /bin/bash



echo -e "\e[1;91mEmerge git....."

#git config --global user.name jinleileiking
#git config --global user.email jinleileiking@gmail.com

mkdir /boot/grub

echo -e "\e[1;91mGet Gento Config Files from git hub....."

cd /
git init
git remote add http https://jinleileiking@github.com/jinleileiking/GentooCfgFiles.git
git fetch http
git branch master http/master 
git checkout master

##################################################
echo -e "\e[1;91mCheck make.conf, conf.d/hostname conf.d/net, /etc/fstab, boot/grub/grub.conf....."
#################################################

echo -e "\e[1;91m!!!!!Modify make.conf!!!!!!.....\e[0m"


echo -e "\e[1;91mUpdating Emerge database and make kernel.....\e[0m"

emerge --sync  --quiet
eselect profile select
emerge gentoo-sources
make menuconfig

# file system ext2,ext4
# cpu type
# smp
# device->wirelsee->ar5xxx

make && make modules_install


echo -e "\e[1;91m!!!!!!!!!!Change version!!!!!!"

########################################################
cp arch/x86_64/boot/bzImage /boot/kernel-3.2.??-gentoo-r2
########################################################



echo -e "\e[1;91mSetup Net!!....."

cd /etc/init.d
############################################
ln -s net.lo net.eth0
rc-update add net.eth0 default
ln -s net.lo net.wlan0
rc-update add net.wlan0 default
############################################



# make sure use the newest vbox-guest-additions......
emerge syslog-ng dhcpcd grub 

##option del after
rc-update add sshd default 


echo -e "\e[1;91mSet Root Password!!....."
passwd
#
#
grub --no-floppy

###################
#root (hd0,0)  
#setup (hd0)   
#quit   
###################

reboot

##################Now using harddisk linux, root########telnet it, You can use copy & past########################################


emerge xorg-server virtualbox-guest-additions terminator sudo google-chrome  git sudo
emerge awesome
emerge kdebase-startkde xdm





rc-update add virtualbox-guest-additions default






echo "exec startkde" > ~/.xinitrc


rc-update add dbus default # chromium need it
rc-update add syslog-ng default 


visudo
# uncomment %wheel line





echo -e "\e[1;91mAdding user........."
useradd -m -G root -s /bin/bash jinleileiking
usermod -a -G vboxguest jinleileiking
passwd jinleileiking
#
#

su jinleileiking

echo -e "\e[1;91mcloning Dotfiles...."
cd ~
git init
git remote add http https://jinleileiking@github.com/jinleileiking/DotFiles.git
git fetch http
git branch master http/master 
git checkout master


##################Now using harddisk linux, user, gui################################################

########useradd -m -G root,usb,wheel,portage,bin,daemon,sys,adm,video,mongodb,redis,tty,disk,lp,mem,kmem,floppy,news,uucp,console,audio,cdrom,tape,cdrw,users,utmp,man,sshd,messagebus,lpadmin,mail,postmaster,ssmtp -s /bin/bash jinleileiking




emerge    zsh  wqy-microhei ubuntu-font-family   eix gentoolkit flaggie cscope ctags ack gvim pciutils  axel aria2 adobe-flash layman wpa_supplicant

emerge mongodb redis memcached pygments 
emerge feh pcmanfm scrot alsa-mixer porthole  virtualbox  



echo -e "\e[1;91mEmerge Packages...."
emerge -u world

#echo -e "\e[1;91mInstalling gvim....."
#git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
#vim +BundleInstall +qa
#cd ~/.vim/bundle/Command-T/ruby/command-t/; ruby extconf.rb; make; cd -

echo -e "\e[1;91mInstalling OH MY ZSH....."
#git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
chsh -s /bin/zsh


###################################################################################
easy_install pygments 
sudo mkdir /data/db -p


 



########################################################################################
echo -e "\e[1;91mInstalling rvm....."
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
. .bashrc
rvm requirements
emerge libiconv readline zlib openssl curl git libyaml sqlite libxslt libtool gcc autoconf automake bison m4
rvm install 1.9.3
rvm 1.9.3
gem install bundler
cd ~
bundle install

##########################################################################################



#Sound 

rc-update add alsasound boot
alsamixer
##############################################

# emerge --update --deep --with-bdeps=y world # dont do this!!!!!