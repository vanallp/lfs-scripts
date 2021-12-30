# lfs-scripts :penguin:
Instructions and scripts to build [LFS](https://linuxfromscratch.org) (Linux From Scratch), the dev version of 11.0. I'm performing the build on a Fedora 34 Workstation.
This script is still under construction...  !!!!

# Foreword

First, this guide does not replace reading the whole LFS book(v11.0 is current). [Read it!](https://www.linuxfromscratch.org/lfs/view/stable/)
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
kernel="5.15.6"

dnf install -y vim-default-editor --allowerasing
dnf -y group install "C Development Tools and Libraries"
dnf -y group install "Development Tools"
dnf -y install texinfo
dnf -y erase byacc
dnf -y reinstall bison
ln -s `which bison` /usr/bin/yacc
export LFS=/mnt/lfs
echo "export LFS=/mnt/lfs" >>  .bash_profile 
mkdir -vp $LFS/sources
chmod -v a+wt $LFS/sources
git clone https://github.com/vanallp/lfs-scripts.git $LFS/sources/lfs-scripts

wget https://www.linuxfromscratch.org/lfs/view/systemd/md5sums --directory-prefix=$LFS/sources
wget https://www.linuxfromscratch.org/lfs/view/systemd/wget-list
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
pushd $LFS/sources
  md5sum -c md5sums
popd

```

Check and confirm everything downloaded and passed OK
```
. $LFS/sources/lfs-scripts/step1.sh
```
will run:
```
#The tcl & procps-ng package must be renamed
mv $LFS/sources/tcl8.6.11-src.tar.gz $LFS/sources/tcl8.6.11.tar.gz
mv $LFS/sources/procps-ng-3.3.17.tar.xz $LFS/sources/procps-3.3.17.tar.xz

# https://www.kernel.org
cd $LFS/sources
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-"$kernel".tar.xz;rc=$?;echo kernel-"$kernel" $rc > wget.log

## blfs 
echo "lfs-system2.sh " >> wget.log
for getfile in $(grep "#wget" lfs-scripts/lfs-system2.sh    | cut -c 7- ); do wget $getfile;rc=$?;echo $getfile $rc >> wget.log;done
echo "blfs-3afterlfs.sh " >> wget.log
for getfile in $(grep "#wget" lfs-scripts/blfs-3afterlfs.sh | cut -c 7- ); do wget $getfile;rc=$?;echo $getfile $rc >> wget.log; done
echo "blfs-4security.sh " >> wget.log
for getfile in $(grep "#wget" lfs-scripts/blfs-4security.sh | cut -c 7- ); do wget $getfile;rc=$?;echo $getfile $rc >> wget.log; done
echo "blfs-5filedisk.sh " >> wget.log
for getfile in $(grep "#wget" lfs-scripts/blfs-5filedisk.sh | cut -c 7- ); do wget $getfile;rc=$?;echo $getfile $rc >> wget.log; done
echo "blfs-11generalutil.sh " >> wget.log
for getfile in $(grep "#wget" lfs-scripts/blfs-11generalutil.sh  | cut -c 7- ); do wget $getfile;rc=$?;echo $getfile $rc >> wget.log; done
echo "blfs-15networking.sh " >> wget.log
for getfile in $(grep "#wget" lfs-scripts/blfs-15networking.sh   | cut -c 7- ); do wget $getfile;rc=$?;echo $getfile $rc >> wget.log; done
cat wget.log




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
chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
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
```
. /mnt/lfs/sources/lfs-scripts/step2.sh
```

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
source ~/.bash_profile
kernel="5.15.6"
.  $LFS/sources/lfs-scripts/lfs-cross.sh
```
# Chapter 7
Return to being root:

```
exit
```

:point_right: Run commands below as root. Make root own the entire filesystem again:
```
. $LFS/sources/lfs-scripts/step3.sh
```

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

 7.4  Enter the chroot environment:

```
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h
```

Create essential directories, files and symlinks:
```
. $LFS/sources/lfs-scripts/step4.sh
```

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
cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/bin/false
systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false
systemd-network:x:76:76:systemd Network Management:/:/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false
systemd-coredump:x:79:79:systemd Core Dumper:/:/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/bin/false
systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/bin/false
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
systemd-journal:x:23:
input:x:24:
mail:x:34:
kvm:x:61:
systemd-bus-proxy:x:72:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
systemd-coredump:x:79:
uuidd:x:80:
systemd-oom:x:81:81:
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
kernel="5.15.6"
. sources/lfs-scripts/lfs-chroot.sh 
```
If you wish to make a backup at this step you can.
Leave the chroot environment and unmount the kernel virtual file systems
Otherwise jump to the final build phase.

```
exit
#cd $LFS/tools/$LFS_TGT
#bin/strip --strip-unneeded $LFS/usr/lib/*
#bin/strip --strip-unneeded $LFS/usr/{,s}bin/*
#bin/strip --strip-unneeded $LFS/tools/bin/*

umount $LFS/dev{/pts,}
umount $LFS/{sys,proc,run}
# backup
cd $LFS 
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

# chap 8

kernel="5.15.6"
. sources/lfs-scripts/lfs-system.sh

exec /bin/bash --login +h
passwd root
kernel="5.15.6"
. sources/lfs-scripts/lfs-system2.sh 
```


Logout from the chroot environment and re-enter it with updated configuration:

```
logout
chroot "$LFS" /usr/bin/env -i          \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login

find /usr/lib /usr/libexec -name \*.la -delete
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
userdel -r tester


```

Run the final script to configure the rest of the system:

```
kernel="5.15.6"
. sources/lfs-scripts/lfs-final.sh 
```

```
General setup -->
   [ ] Auditing Support [CONFIG_AUDIT]
   [*] Control Group support [CONFIG_CGROUPS]
   [ ] Enable deprecated sysfs features to support old userspace tools [CONFIG_SYSFS_DEPRECATED]
   [*] Configure standard kernel features (expert users) [CONFIG_EXPERT] --->
      [*] open by fhandle syscalls [CONFIG_FHANDLE]

Processor type and features --->  ( all defaults )                                         ***=edit
  [*] EFI runtime service support                              [CONFIG_EFI]
  [*]   EFI stub support                                       [CONFIG_EFI_STUB]
  [*]     EFI mixed-mode support

Firmware Drivers --->             ( all defaults ) 
  EFI (Extensible Firmware Interface) Support --->
    < > EFI Variable Support via sysfs                         [CONFIG_EFI_VARS]           *** off!
    [*] Export efi runtime maps to sysfs                       [CONFIG_EFI_RUNTIME_MAP]

    [*] Export DMI identification via sysfs to userspace [CONFIG_DMIID]
General architecture-dependent options  --->
    [*] Enable seccomp to safely compute untrusted bytecode [CONFIG_SECCOMP]
Networking support  --->
   Networking options  --->
    <*> The IPv6 protocol [CONFIG_IPV6]

Enable the block layer --->       ( all defaults )
  Partition Types --->
    [*] Advanced partition selection                           [CONFIG_PARTITION_ADVANCED] ***
    [*] EFI GUID Partition support                             [CONFIG_EFI_PARTITION]
Device Drivers --->               
  Generic Driver Options  --->
    [ ] Support for uevent helper                               [CONFIG_UEVENT_HELPER]
    [*] Maintain a devtmpfs filesystem to mount at /dev         [CONFIG_DEVTMPFS]
    Firmware Loader --->
      [ ] Enable the firmware sysfs fallback mechanism [CONFIG_FW_LOADER_USER_HELPER]
  Graphics support --->
    Frame buffer Devices --->
      Support for frame buffer devices --->                    [CONFIG_FB]
        [*] EFI-based Framebuffer support                      [CONFIG_FB_EFI]
    Console display driver support --->
      [*] Framebuffer Console support                          [CONFIG_FRAMEBUFFER_CONSOLE]
  Input device support --->
    <*> Generic input layer (needed for keyboard, mouse, ...) [CONFIG_INPUT]
    <*>   Event interface                   [CONFIG_INPUT_EVDEV]
    [*]   Miscellaneous devices  --->       [CONFIG_INPUT_MISC]
      <*>    User level driver support      [CONFIG_INPUT_UINPUT]
  Graphics support --->
   <*> Direct Rendering Manager (XFree86 ... support) ---> [CONFIG_DRM]
   <*> Intel 8xx/9xx/G3x/G4x/HD Graphics                   [CONFIG_DRM_I915]

File systems --->
    [*] Inotify support for userspace [CONFIG_INOTIFY_USER]
  Pseudo filesystems --->
    <*/M> EFI Variable filesystem                              [CONFIG_EFIVAR_FS]

  <*/M> XFS filesystem support                                 [CONFIG_XFS_FS]
```

# The end

You can now create a new VM using the virtual hard disk with the LFS build. It will be bootable and fully functional. Enjoy!
