#!/bin/bash

#The tcl & procps-ng package must be renamed
mv $LFS/sources/tcl8.6.11-src.tar.gz $LFS/sources/tcl8.6.11.tar.gz
mv $LFS/sources/procps-ng-3.3.17.tar.xz $LFS/sources/procps-3.3.17.tar.xz

# vim https://github.com/vim/vim/releases
# https://www.kernel.org/ & vim
cd $LFS/sources
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-"$kernel".tar.xz

## blfs
for getfile in $(grep "#wget" lfs-scripts/lfs-system2.sh    | cut -c 7- ); do wget $getfile; done
for getfile in $(grep "#wget" lfs-scripts/blfs-3afterlfs.sh | cut -c 7- ); do wget $getfile; done
for getfile in $(grep "#wget" lfs-scripts/blfs-4security.sh | cut -c 7- ); do wget $getfile; done
for getfile in $(grep "#wget" lfs-scripts/blfs-5filedisk.sh | cut -c 7- ); do wget $getfile; done
for getfile in $(grep "#wget" lfs-scripts/blfs-11generalutil.sh  | cut -c 7- ); do wget $getfile; done
for getfile in $(grep "#wget" lfs-scripts/blfs-15networking.sh   | cut -c 7- ); do wget $getfile; done

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done
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

