#!/bin/bash
# BLFS 10.1 Build Script

package_name=""
package_ext=""

begin() {
	package_name=$1
	package_ext=$2
	
	echo "[lfs-scripts] Starting build of $package_name at $(date)"
	
	tar xf $package_name.$package_ext
	cd $package_name
}

finish() {
	echo "[lfs-scripts] Finishing build of $package_name at $(date)"

	cd /sources
	rm -rf $package_name
}

cd /sources


#     https://github.com/htop-dev/htop/archive/refs/tags/3.0.5.tar.gz
#wget https://github.com/htop-dev/htop/archive/refs/tags/3.0.5.tar.gz
cd /sources
mv 3.0.5.tar.gz htop-3.0.5.tar.gz
begin htop-3.0.5 tar.gz
./autogen.sh && ./configure --prefix=/usr && make
make install ;rc=$?;echo $package_name $rc >> /sources/11rc.log
finish
#cd /sources/blfs-systemd-units
#make install-rsyncd

#     https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
#wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
begin  libevent-2.1.12-stable tar.gz
sed -i 's/python/&3/' event_rpcgen.py
./configure --prefix=/usr --disable-static &&
make
make install;rc=$?;echo $package_name $rc >> /sources/11rc.log
finish

#     https://github.com/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz
#wget https://github.com/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz
#requires ncurses libevent-2
begin tmux-3.2a tar.gz
./configure --prefix=/usr 
make
make install;rc=$?;echo $package_name $rc >> /sources/11rc.log
finish



#  Cleaning Up
rm -rf /tmp/*a

echo "blfs-11.sh"
cat  /sources/11rc.log

