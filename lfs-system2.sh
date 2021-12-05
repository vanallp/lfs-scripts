#!/bin/bash
# LFS 10.0 Build Script
# Builds the basic system software from chapter 8
# by Luís Mendes :)
# 16/09/2020

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


# 8.35. Libtool-2.4.6
begin libtool-2.4.6 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
rm -fv /usr/lib/libltdl.a
finish

# 8.36. GDBM-1.22
begin gdbm-1.22 tar.gz
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.37. Gperf-3.1
begin gperf-3.1 tar.gz
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.38. Expat-2.4.1
begin expat-2.4.1 tar.xz
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.4.1
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.4.1
finish

# 8.39. Inetutils-2.2
begin inetutils-2.2 tar.xz
./configure --prefix=/usr        \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/{,s}bin/ifconfig
finish

# 8.40. Less-590
begin less-590 tar.gz
./configure --prefix=/usr --sysconfdir=/etc
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.41. Perl-5.34.0
begin perl-5.34.0 tar.xz
patch -Np1 -i ../perl-5.34.0-upstream_fixes-1.patch
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des                                         \
             -Dprefix=/usr                                \
             -Dvendorprefix=/usr                          \
             -Dprivlib=/usr/lib/perl5/5.34/core_perl      \
             -Darchlib=/usr/lib/perl5/5.34/core_perl      \
             -Dsitelib=/usr/lib/perl5/5.34/site_perl      \
             -Dsitearch=/usr/lib/perl5/5.34/site_perl     \
             -Dvendorlib=/usr/lib/perl5/5.34/vendor_perl  \
             -Dvendorarch=/usr/lib/perl5/5.34/vendor_perl \
             -Dman1dir=/usr/share/man/man1                \
             -Dman3dir=/usr/share/man/man3                \
             -Dpager="/usr/bin/less -isR"                 \
             -Duseshrplib                                 \
             -Dusethreads
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
unset BUILD_ZLIB BUILD_BZIP2
finish

# 8.42. XML::Parser-2.46
begin XML-Parser-2.46 tar.gz
perl Makefile.PL
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.43. Intltool-0.51.0
begin intltool-0.51.0 tar.gz
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
finish

# 8.44. Autoconf-2.71
begin autoconf-2.71 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.45. Automake-1.16.5
begin automake-1.16.5 tar.xz
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.5
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.46. Kmod-29
begin kmod-29 tar.xz
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --with-xz              \
	    --with-zstd            \
            --with-zlib
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done
ln -sfv kmod /bin/lsmod
finish

# 8.47. Libelf from Elfutils-0.186
begin elfutils-0.186 tar.bz2
./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy 
make
make -C libelf install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /lib/libelf.a
finish

# 8.48. Libffi-3.4.2
begin libffi-3.4.2 tar.gz
./configure --prefix=/usr --disable-static --with-gcc-arch=native --disable-exec-static-tramp
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.49. OpenSSL-1.1.1l
begin openssl-1.1.1l tar.gz
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1l
cp -vfr doc/* /usr/share/doc/openssl-1.1.1l
finish

# 8.50. Python-3.10.0
begin Python-3.10.0 tar.xz
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes \
	    --enable-optimizations
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -v -dm755 /usr/share/doc/python-3.10.0/html 
tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.10.0/html \
    -xvf ../python-3.10.0-docs-html.tar.bz2
finish

# 8.51. Ninja-1.10.2
begin ninja-1.10.2 tar.gz
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc
python3 configure.py --bootstrap
install -vm755 ninja /usr/bin/;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
finish

# 8.52. Meson-0.60.2
begin meson-0.60.2 tar.gz
python3 setup.py build
python3 setup.py install --root=dest;rc=$?;echo $package_name $rc >> /sources/systemrc.log
cp -rv dest/* /
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson
finish

# 8.53. Coreutils-9.0
begin coreutils-9.0 tar.xz
patch -Np1 -i ../coreutils-9.0-i18n-1.patch
#sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
autoreconf -fiv 
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
finish

# 8.54. Check-0.15.2
begin check-0.15.2 tar.gz
./configure --prefix=/usr --disable-static
make
make docdir=/usr/share/doc/check-0.15.2 install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.55. Diffutils-3.8
begin diffutils-3.8 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.55. Gawk-5.1.1
begin gawk-5.1.1 tar.xz
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mkdir -v /usr/share/doc/gawk-5.1.1
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.1
finish

# 8.57. Findutils-4.8.0
begin findutils-4.8.0 tar.xz
./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.58. Groff-1.22.4
begin groff-1.22.4 tar.gz
PAGE=letter ./configure --prefix=/usr
make -j1
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.59 grub   after...

#efivar efivar-37.tar.bz2
#wget https://github.com/rhboot/efivar/releases/download/37/efivar-37.tar.bz2
#wget https://www.linuxfromscratch.org/patches/blfs/svn/efivar-37-gcc_9-1.patch
begin efivar-37 tar.bz2
patch -Np1 -i ../efivar-37-gcc_9-1.patch
make CFLAGS="-O2 -Wno-stringop-truncation"
make install LIBDIR=/usr/lib ;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

#popt-1.18.tar.gz
#wget http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.18.tar.gz
begin popt-1.18 tar.gz
./configure --prefix=/usr --disable-static &&
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

#efibootmgr-17.tar.gz
# https://github.com/rhboot/efibootmgr/archive/17/efibootmgr-17.tar.gz
#wget https://github.com/rhboot/efibootmgr/releases/download/17/efibootmgr-17.tar.bz2
begin efibootmgr-17 tar.bz2
sed -e '/extern int efi_set_verbose/d' -i src/efibootmgr.c
make EFIDIR=LFS EFI_LOADER=grubx64.efi
make install EFIDIR=LFS ;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

#freetype-2.11.1.tar.xz
#wget https://downloads.sourceforge.net/freetype/freetype-2.11.1.tar.xz
begin freetype-2.11.1 tar.xz
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&

./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
make install ;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.59. GRUB-2.06
#wget https://unifoundry.com/pub/unifont/unifont-13.0.06/font-builds/unifont-13.0.06.pcf.gz
begin grub-2.06 tar.xz
mkdir -pv /usr/share/fonts/unifont &&
gunzip -c ../unifont-13.0.06.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-efiemu       \
	    --enable-grub-mkfont \
            --with-platform=efi  \
            --disable-werror     &&
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
finish

# 8.60. Gzip-1.10
begin gzip-1.10 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.61. IPRoute2-5.15.0
begin iproute2-5.15.0 tar.xz
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
sed -i 's/.m_ipt.o//' tc/Makefile
make
make SBINDIR=/usr/sbin install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mkdir -v              /usr/share/doc/iproute2-5.15.0
cp -v COPYING README* /usr/share/doc/iproute2-5.15.0
finish

# 8.62. Kbd-2.4.0
begin kbd-2.4.0 tar.xz
patch -Np1 -i ../kbd-2.4.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mkdir -v            /usr/share/doc/kbd-2.4.0
cp -R -v docs/doc/* /usr/share/doc/kbd-2.4.0
finish

# 8.63. Libpipeline-1.5.4
begin libpipeline-1.5.4 tar.gz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.64. Make-4.3
begin make-4.3 tar.gz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.65. Patch-2.7.6
begin patch-2.7.6 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.66. Tar-1.34
begin tar-1.34 tar.xz
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr 
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
make -C doc install-html docdir=/usr/share/doc/tar-1.34
finish

# 8.67. Texinfo-6.8
begin texinfo-6.8 tar.xz
./configure --prefix=/usr 
sed -e 's/__attribute_nonnull__/__nonnull/' \
    -i gnulib/lib/malloc/dynarray-skeleton.c
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
make TEXMF=/usr/share/texmf install-tex
pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd
finish

# 8.68. Vim-8.2.3704
begin vim-8.2.3704 tar.gz
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim82/doc /usr/share/doc/vim-8.2.3704
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
finish

# 8.69 MarkupSafe-2.0.1
begin MarkupSafe-2.0.1 tar.gz
python3 setup.py build
python3 setup.py install --optimize=1;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.70. Jinja2-3.0.3
begin Jinja2-3.0.3 tar.gz
python3 setup.py install --optimize=1;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.71. Systemd-249
begin systemd-249 tar.gz
patch -Np1 -i ../systemd-249-upstream_fixes-1.patch
sed -i -e 's/GROUP="render"/GROUP="video"/' \
        -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in
sed -i 's/+ want_libfuzzer.*$/and want_libfuzzer/' meson.build
sed -i '/ARPHRD_CAN/a#define ARPHRD_MCTP        290' src/basic/linux/if_arp.h
mkdir -p build
cd       build

LANG=en_US.UTF-8                    \
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      --buildtype=release           \
      -Dblkid=true                  \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Ddocdir=/usr/share/doc/systemd-249 \
      ..
LANG=en_US.UTF-8 ninja
LANG=en_US.UTF-8 ninja install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
tar -xf ../../systemd-man-pages-249.tar.xz --strip-components=1 -C /usr/share/man
rm -rf /usr/lib/pam.d
systemd-machine-id-setup
systemctl preset-all
systemctl disable systemd-time-wait-sync.service
finish

# 8.72. D-Bus-1.12.20
begin dbus-1.12.20 tar.gz
./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --disable-static                     \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --docdir=/usr/share/doc/dbus-1.12.20 \
            --with-console-auth-dir=/run/console \
            --with-system-pid-file=/run/dbus/pid \
            --with-system-socket=/run/dbus/system_bus_socket
make
make install ;rc=$?;echo $package_name $rc >> /sources/systemrc.log
ln -sfv /etc/machine-id /var/lib/dbus
finish

# 8.73. Man-DB-2.9.4          
begin man-db-2.9.4 tar.xz
./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.9.4 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap            \
            --with-systemdtmpfilesdir=           \
            --with-systemdsystemunitdir=
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish


# 8.74. Procps-ng-3.3.17
# This package extracts to the directory procps-3.3.17, not the expected procps-ng-3.3.17
# the tar file was renamed after d/l 
begin procps-3.3.17 tar.xz
./configure --prefix=/usr                            \
            --docdir=/usr/share/doc/procps-ng-3.3.17 \
            --disable-static                         \
            --disable-kill                           \
	    --with-systemd
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.75. Util-linux-2.37.2
begin util-linux-2.37.2 tar.xz
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
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
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.76. E2fsprogs-1.46.4
begin e2fsprogs-1.46.4 tar.gz
mkdir -v build
cd       build
../configure --prefix=/usr           \
	     --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
finish


# 8.77. Stripping Again
save_usrlib="$(cd /usr/lib; ls ld-linux*)
             libc.so.6
             libthread_db.so.1
             libquadmath.so.0.0.0 
             libstdc++.so.6.0.29
             libitm.so.1.0.0 
             libatomic.so.1.2.0" 

cd /usr/lib

for LIB in $save_usrlib; do
    objcopy --only-keep-debug $LIB $LIB.dbg
    cp $LIB /tmp/$LIB
    strip --strip-unneeded /tmp/$LIB
    objcopy --add-gnu-debuglink=$LIB.dbg /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

online_usrbin="bash find strip"
online_usrlib="libbfd-2.37.so
               libhistory.so.8.1
               libncursesw.so.6.3
               libm.so.6
               libreadline.so.8.1
               libz.so.1.2.11
               $(cd /usr/lib; find libnss*.so* -type f)"

for BIN in $online_usrbin; do
    cp /usr/bin/$BIN /tmp/$BIN
    strip --strip-unneeded /tmp/$BIN
    install -vm755 /tmp/$BIN /usr/bin
    rm /tmp/$BIN
done

for LIB in $online_usrlib; do
    cp /usr/lib/$LIB /tmp/$LIB
    strip --strip-unneeded /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

for i in $(find /usr/lib -type f -name \*.so* ! -name \*dbg) \
         $(find /usr/lib -type f -name \*.a)                 \
         $(find /usr/{bin,sbin,libexec} -type f); do
    case "$online_usrbin $online_usrlib $save_usrlib" in
        *$(basename $i)* ) 
            ;;
        * ) strip --strip-unneeded $i 
            ;;
    esac
done

unset BIN LIB save_usrlib online_usrbin online_usrlib


# 8.78. Cleaning Up
rm -rf /tmp/*a

cd /

echo "lfs-system2.sh"
cat  /sources/systemrc.log

