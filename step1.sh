#!/bin/bash

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

su - lfs

