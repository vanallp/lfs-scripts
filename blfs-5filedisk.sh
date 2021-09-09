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


# 
#cd /sources/blfs-systemd-units
#make install-sshd


#     https://ftp.gnu.org/gnu/parted/parted-3.4.tar.xz
#wget https://ftp.gnu.org/gnu/parted/parted-3.4.tar.xz
begin parted-3.4 tar.xz
./configure --prefix=/usr  \
	    --disable-static \
	    --disable-device-mapper
make 

make -C doc html                                       
makeinfo --html      -o doc/html       doc/parted.texi 
makeinfo --plaintext -o doc/parted.txt doc/parted.texi

make install ;rc=$?;echo $package_name $rc >> /sources/5rc.log
install -v -m755 -d /usr/share/doc/parted-3.4/html 
install -v -m644    doc/html/* \
                    /usr/share/doc/parted-3.4/html 
install -v -m644    doc/{FAT,API,parted.{txt,html}} \
                    /usr/share/doc/parted-3.4

install -v -m644 doc/FAT doc/API doc/parted.{pdf,ps,dvi} \
                    /usr/share/doc/parted-3.4
finish

#     https://github.com/benhoyt/inih/archive/r53/inih-r53.tar.gz
#wget https://github.com/benhoyt/inih/archive/r53/inih-r53.tar.gz
begin inih-r53 tar.gz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release .. &&
ninja
ninja install;rc=$?;echo $package_name $rc >> /sources/5rc.log
finish

Requires inih-53
#     https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.13.0.tar.xz
#wget https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-5.13.0.tar.xz
begin xfsprogs-5.13.0 tar.xz
make DEBUG=-DNDEBUG     \
     INSTALL_USER=root  \
     INSTALL_GROUP=root;rc=$?;echo $package_name $rc >> /sources/5rc.log
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-5.13.0 install     &&
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-5.13.0 install-dev &&
rm -rfv /usr/lib/libhandle.{a,la}
finish





#  Cleaning Up
rm -rf /tmp/*a

echo "blfs-5.sh"
cat  /sources/5rc.log

