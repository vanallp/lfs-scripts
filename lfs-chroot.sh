#!/bin/bash
# LFS 11.1 Build Script
# Builds the additional temporary tools from chapter 7
# by Luís Mendes :)
# 14/09/2020
#  paul

package_name=""
package_ext=""

begin() {
	package_name=$1
	package_ext=$2
	
	tar xf $package_name.$package_ext
	cd $package_name
}

finish() {
	cd /sources
	rm -rf $package_name
}

cd /sources

# 7.7. Libstdc++ from GCC-11.2.0, Pass 2
begin gcc-11.2.0 tar.xz
ln -s gthr-posix.h libgcc/gthr-default.h
mkdir -v build
cd       build
../libstdc++-v3/configure            \
    CXXFLAGS="-g -O2 -D_GNU_SOURCE"  \
    --prefix=/usr                    \
    --disable-multilib               \
    --disable-nls                    \
    --host=$(uname -m)-lfs-linux-gnu \
    --disable-libstdcxx-pch
make
make install;rc=$?;echo $package_name $rc >> /sources/rc.log
finish

# 7.8. Gettext-0.21
begin gettext-0.21 tar.xz
./configure --disable-shared
make ;rc=$?;echo $package_name $rc >> /sources/rc.log
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
finish

# 7.9. Bison-3.8.2
begin bison-3.8.2 tar.xz
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make
make install ;rc=$?;echo $package_name $rc >> /sources/rc.log
finish

# 7.10. Perl-5.34.0
begin perl-5.34.0 tar.xz
sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Dprivlib=/usr/lib/perl5/5.34/core_perl     \
             -Darchlib=/usr/lib/perl5/5.34/core_perl     \
             -Dsitelib=/usr/lib/perl5/5.34/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.34/site_perl    \
             -Dvendorlib=/usr/lib/perl5/5.34/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.34/vendor_perl
make
make install ;rc=$?;echo $package_name $rc >> /sources/rc.log
finish

# 7.11. Python-3.9.7 (upper case P)
begin Python-3.9.7 tar.xz
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip
make
make install ;rc=$?;echo $package_name $rc >> /sources/rc.log
finish

# 7.12. Texinfo-6.8
begin texinfo-6.8 tar.xz
sed -e 's/__attribute_nonnull__/__nonnull/' \
    -i gnulib/lib/malloc/dynarray-skeleton.c
./configure --prefix=/usr
make
make install ;rc=$?;echo $package_name $rc >> /sources/rc.log
finish

# 7.13. Util-linux-2.37.2
begin util-linux-2.37.2 tar.xz
mkdir -pv /var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
	    --libdir=/usr/lib    \
            --docdir=/usr/share/doc/util-linux-2.37.2 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
	    runstatedir=/run
make
make install ;rc=$?;echo $package_name $rc >> /sources/rc.log
finish

# 7.14 
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /usr/share/{info,man,doc}/*
rm -rf /tools

cd /

echo "lfs-chroot"
cat /sources/rc.log

