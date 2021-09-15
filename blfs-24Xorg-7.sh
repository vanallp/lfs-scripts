#!/bin/bash
# BLFS 10.1 Build Script

package_name=""
package_ext=""

begin() {
	package_name=$1
	package_ext=$2
	
	echo "[lfs-scripts] Starting build of $package_name at $(date)"
        cd /sources	
	tar xf $package_name.$package_ext
	cd $package_name
}

finish() {
	echo "[lfs-scripts] Finishing build of $package_name at $(date)"

	cd /sources
	rm -rf $package_name
}

#wget https://github.com/htop-dev/htop/archive/refs/tags/3.0.5.tar.gz
#cd /sources
#mv 3.0.5.tar.gz htop-3.0.5.tar.gz
#begin htop-3.0.5 tar.gz
#make install ;rc=$?;echo $package_name $rc >> /sources/24rc.log
#finish
#cd /sources/blfs-systemd-units
#make install-rsyncd




#  Cleaning Up
rm -rf /tmp/*a
echo "blfs-24.sh"
cat  /sources/24.log

