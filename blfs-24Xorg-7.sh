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

cd /sources

# https://www.x.org/pub/individual/util/util-macros-1.19.3.tar.bz2
wget --no-check-certificate  https://www.x.org/pub/individual/util/util-macros-1.19.3.tar.bz2
begin util-macros-1.19.3 tar.bz2
./configure $XORG_CONFIG
make install 
finish

#  Cleaning Up
rm -rf /tmp/*a
echo "blfs-24.sh"
cat  /sources/24.log

