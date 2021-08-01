# lfs-scripts :penguin:
Instructions and scripts to build LFS (Linux From Scratch), version 10.1. I'm performing the build on a Fedora 34 Workstation.
This script is still under construction...  !!!!

# Foreword

First, this guide does not replace reading the whole LFS book(v10.1 is current). [Read it!](https://www.linuxfromscratch.org/lfs/view/stable/)
This build will be accomplished inside a Fedora release 34 machine formatted with:

```
 single 128G disk - manually formatted as:

sda1 /boot/efi 600MiB
sda2 /          26GiB ext4
sda3 /mnt/lfs  [everything else] ext4
```


Pick a kernel. [here](https://www.kernel.org/)

# Build instructions

:point_right: Run commands below as root.

```
# several times below I have to set the kernel version with:
kernel="5.13.5"

dnf install -y vim-default-editor --allowerasing
dnf -y group install "C Development Tools and Libraries"
dnf -y group install "Development Tools"
dnf -y install texinfo
dnf -y erase byacc
dnf -y reinstall bison
ln -s `which bison` /usr/bin/yacc
export LFS=/mnt/lfs
echo "export LFS=/mnt/lfs" >>  .bash_profile 
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
git clone https://github.com/vanallp/lfs-scripts.git $LFS/sources
wget https://www.linuxfromscratch.org/lfs/view/10.1/wget-list
wget https://prdownloads.sourceforge.net/expat/expat-2.4.1.tar.xz --directory-prefix=$LFS/sources
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
wget https://www.linuxfromscratch.org/lfs/view/10.1/md5sums --directory-prefix=$LFS/sources

pushd $LFS/sources
  md5sum -c md5sums
popd

```

Check and confirm everything downloaded and passed OK
. $LFS/sources/lfs-scripts/step1.sh

```
#The tcl & procps-ng package must be renamed
mv $LFS/sources/tcl8.6.11-src.tar.gz $LFS/sources/tcl8.6.11.tar.gz
mv $LFS/sources/procps-ng-3.3.17.tar.xz $LFS/sources/procps-3.3.17.tar.xz

# vim https://github.com/vim/vim/releases
# https://www.kernel.org/ & vim
cd $LFS/sources
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-"$kernel".tar.xz
wget https://github.com/vim/vim/archive/refs/tags/v8.2.3043.tar.gz
mv v8.2.3043.tar.gz vim-8.2.3043.tar.gz
wget https://github.com/rhboot/efivar/releases/download/37/efivar-37.tar.bz2
wget https://www.linuxfromscratch.org/patches/blfs/svn/efivar-37-gcc_9-1.patch
wget https://github.com/rhboot/efibootmgr/archive/17/efibootmgr-17.tar.gz
wget http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.18.tar.gz
wget https://downloads.sourceforge.net/freetype/freetype-2.10.4.tar.xz
wget https://ftp.gnu.org/gnu/grub/grub-2.06.tar.xz
wget https://unifoundry.com/pub/unifont/unifont-13.0.06/font-builds/unifont-13.0.06.pcf.gz
wget https://downloads.sourceforge.net/freetype/freetype-2.10.4.tar.xz


## blfs 
wget https://curl.se/download/curl-7.78.0.tar.xz
wget https://www.kernel.org/pub/software/scm/git/git-2.32.0.tar.xz
wget https://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20210711.tar.xz
wget https://www.samba.org/ftp/rsync/src/rsync-3.2.3.tar.gz
wget https://ftp.gnu.org/gnu/wget/wget-1.21.1.tar.gz
wget https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.6p1.tar.gz
wget https://www.sudo.ws/dist/sudo-1.9.7p1.tar.gz
wget https://ftp.gnu.org/gnu/parted/parted-3.4.tar.xz

mkdir -pv $LFS/{bin,etc,lib,sbin,usr,var}
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
mkdir -pv $LFS/tools

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
# passwd lfs
chown -v lfs $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
chown -v lfs $LFS/sources
```


Login as the lfs user:


```
su - lfs
```

:point_right: Run commands below as lfs.
. $LFS/sources/lfs-scripts/step2.sh

```
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
export LFS LC_ALL LFS_TGT PATH
EOF
```


Run the lfs-cross.sh script, which will build the cross-toolchain and cross compiling temporary tools from chapters 5 and 6:



```
source ~/.bashrc
kernel="5.13.5"
.  $LFS/sources/lfs-scripts/lfs-cross.sh | tee $LFS/sources/lfs-cross.log
```

Return to being root:

```
exit
```

:point_right: Run commands below as root. Make root own the entire filesystem again:
. $LFS/sources/lfs-scripts/step3.sh

```
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac
mkdir -pv $LFS/{dev,proc,sys,run}
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3
mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi
```

Enter the chroot environment:

```
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h
```

Create essential directories, files and symlinks:
. $LFS/sources/lfs-scripts/step4.sh

```
mkdir -pv /{boot,home,mnt,opt,srv}
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}
ln -sfv /run /var/run
ln -sfv /run/lock /var/lock
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
ln -sv /proc/self/mounts /etc/mtab
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
wheel:x:97:
nogroup:x:99:
users:x:999:
EOF

echo "tester:x:$(ls -n $(tty) | cut -d" " -f3):101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
exec /bin/bash --login +h
```

# Chapter 7. Entering Chroot and Building Additional Temporary Tools
Run the lfs-chroot.sh script, which will build additional temporary tools:

``` 
kernel="5.13.5"
. sources/lfs-scripts/lfs-chroot.sh | tee /lfs-chroot.log
```

Leave the chroot environment and unmount the kernel virtual file systems

```
exit
umount $LFS/dev{/pts,}
umount $LFS/{sys,proc,run}
strip --strip-debug $LFS/usr/lib/*
strip --strip-unneeded $LFS/usr/{,s}bin/*
strip --strip-unneeded $LFS/tools/bin/*

cd $LFS &&
tar -cJpf $HOME/lfs-temp-tools-10.1.tar.xz .
```


For the final build phase, run the lfs-system.sh script:

``` 
mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h

kernel="5.13.5"
. sources/lfs-scripts/lfs-system.sh | tee /lfs-system.log

exec /bin/bash --login +h
passwd root
kernel="5.13.5"
. sources/lfs-scripts/lfs-system2.sh | tee /lfs-system2.log
```


Logout from the chroot environment and re-enter it with updated configuration:

```
logout
chroot "$LFS" /usr/bin/env -i          \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login
```

Run the final script to configure the rest of the system:

```
kernel="5.13.5"
. sources/lfs-scripts/lfs-final.sh | tee /lfs-final.log
```

```
Processor type and features --->  ( all defaults )
  [*] EFI runtime service support                              [CONFIG_EFI]
  [*]   EFI stub support                                       [CONFIG_EFI_STUB]
  [*]     EFI mixed-mode support
Firmware Drivers --->             ( all defaults ) 
  EFI (Extensible Firmware Interface) Support --->
    < > EFI Variable Support via sysfs                         [CONFIG_EFI_VARS]
    [*] Export efi runtime maps to sysfs                       [CONFIG_EFI_RUNTIME_MAP]
Enable the block layer --->       ( all defaults )
  Partition Types --->
    [*] Advanced partition selection                           [CONFIG_PARTITION_ADVANCED]
    [*] EFI GUID Partition support                             [CONFIG_EFI_PARTITION]
Device Drivers --->               
  Generic Driver Options  --->
    [ ] Support for uevent helper                               [CONFIG_UEVENT_HELPER]
    [*] Maintain a devtmpfs filesystem to mount at /dev         [CONFIG_DEVTMPFS]
  Graphics support --->
    Frame buffer Devices --->
      Support for frame buffer devices --->                    [CONFIG_FB]
        [*] EFI-based Framebuffer support                      [CONFIG_FB_EFI]
    Console display driver support --->
      [*] Framebuffer Console support                          [CONFIG_FRAMEBUFFER_CONSOLE]
File systems --->
  Pseudo filesystems --->
    <*/M> EFI Variable filesystem                              [CONFIG_EFIVAR_FS]
```

# The end

You can now create a new VM using the virtual hard disk with the LFS build. It will be bootable and fully functional. Enjoy!
