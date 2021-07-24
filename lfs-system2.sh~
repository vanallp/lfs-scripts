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

# 8.36. GDBM-1.19
begin gdbm-1.19 tar.gz
sed -r -i '/^char.*parseopt_program_(doc|args)/d' src/parseopt.c
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

# 8.39. Inetutils-2.0
begin inetutils-2.0 tar.xz
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
mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin
finish

# 8.40. Perl-5.32.1
begin perl-5.32.1 tar.xz
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des                                         \
             -Dprefix=/usr                                \
             -Dvendorprefix=/usr                          \
             -Dprivlib=/usr/lib/perl5/5.32/core_perl      \
             -Darchlib=/usr/lib/perl5/5.32/core_perl      \
             -Dsitelib=/usr/lib/perl5/5.32/site_perl      \
             -Dsitearch=/usr/lib/perl5/5.32/site_perl     \
             -Dvendorlib=/usr/lib/perl5/5.32/vendor_perl  \
             -Dvendorarch=/usr/lib/perl5/5.32/vendor_perl \
             -Dman1dir=/usr/share/man/man1                \
             -Dman3dir=/usr/share/man/man3                \
             -Dpager="/usr/bin/less -isR"                 \
             -Duseshrplib                                 \
             -Dusethreads
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
unset BUILD_ZLIB BUILD_BZIP2
finish

# 8.41. XML::Parser-2.46
begin XML-Parser-2.46 tar.gz
perl Makefile.PL
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.42. Intltool-0.51.0
begin intltool-0.51.0 tar.gz
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
finish

# 8.43. Autoconf-2.71
begin autoconf-2.71 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.44. Automake-1.16.3
begin automake-1.16.3 tar.xz
sed -i "s/''/etags/" t/tags-lisp-space.sh
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.3
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.45. Kmod-28
begin kmod-28 tar.xz
./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zlib
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done
ln -sfv kmod /bin/lsmod
finish

# 8.46. Libelf from Elfutils-0.183
begin elfutils-0.183 tar.bz2
./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy \
            --libdir=/lib
make
make -C libelf install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /lib/libelf.a
finish

# 8.47. Libffi-3.3
begin libffi-3.3 tar.gz
./configure --prefix=/usr --disable-static --with-gcc-arch=native
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.48. OpenSSL-1.1.1j
begin openssl-1.1.1j tar.gz
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1j
cp -vfr doc/* /usr/share/doc/openssl-1.1.1j
finish

# 8.49. Python-3.9.2
begin Python-3.9.2 tar.xz
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -v -dm755 /usr/share/doc/python-3.9.2/html 
tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.9.2/html \
    -xvf ../python-3.9.2-docs-html.tar.bz2
finish

# 8.50. Ninja-1.10.2
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

# 8.51. Meson-0.57.1
begin meson-0.57.1 tar.gz
python3 setup.py build
python3 setup.py install --root=dest;rc=$?;echo $package_name $rc >> /sources/systemrc.log
cp -rv dest/* /
finish

# 8.52. Coreutils-8.32
begin coreutils-8.32 tar.xz
patch -Np1 -i ../coreutils-8.32-i18n-1.patch
sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
autoreconf -fiv 
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,nice,sleep,touch} /bin
finish

# 8.53. Check-0.15.2
begin check-0.15.2 tar.gz
./configure --prefix=/usr --disable-static
make
make docdir=/usr/share/doc/check-0.15.2 install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.54. Diffutils-3.7
begin diffutils-3.7 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.55. Gawk-5.1.0
begin gawk-5.1.0 tar.xz
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mkdir -v /usr/share/doc/gawk-5.1.0
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.0
finish

# 8.56. Findutils-4.8.0
begin findutils-4.8.0 tar.xz
./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
finish

# 8.57. Groff-1.22.4
begin groff-1.22.4 tar.gz
PAGE=letter ./configure --prefix=/usr
make -j1
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

#efivar efivar-37.tar.bz2
begin efivar-37 tar.bz2
patch -Np1 -i ../efivar-37-gcc_9-1.patch
make CFLAGS="-O2 -Wno-stringop-truncation"
make install LIBDIR=/usr/lib ;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

#popt-1.18.tar.gz
begin popt-1.18 tar.gz
./configure --prefix=/usr --disable-static &&
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

#efibootmgr-17.tar.gz
begin efibootmgr-17 tar.gz
sed -e '/extern int efi_set_verbose/d' -i src/efibootmgr.c
make EFIDIR=LFS EFI_LOADER=grubx64.efi
make install EFIDIR=LFS ;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

#freetype-2.10.4.tar.xz
begin freetype-2.10.4 tar.xz
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&

./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
make install ;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.58. GRUB-2.04
begin grub-2.06 tar.xz
#sed "s/gold-version/& -R .note.gnu.property/" \
#    -i Makefile.in grub-core/Makefile.in
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

# 8.59. Less-563
begin less-563 tar.gz
./configure --prefix=/usr --sysconfdir=/etc
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.60. Gzip-1.10
begin gzip-1.10 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/bin/gzip /bin
finish

# 8.61. IPRoute2-5.10.0
begin iproute2-5.10.0 tar.xz
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
sed -i 's/.m_ipt.o//' tc/Makefile
make
make DOCDIR=/usr/share/doc/iproute2-5.10.0 install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.62. Kbd-2.4.0
begin kbd-2.4.0 tar.xz
patch -Np1 -i ../kbd-2.4.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
rm -v /usr/lib/libtswrap.{a,la,so*}
mkdir -v            /usr/share/doc/kbd-2.4.0
cp -R -v docs/doc/* /usr/share/doc/kbd-2.4.0
finish

# 8.63. Libpipeline-1.5.3
begin libpipeline-1.5.3 tar.gz
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

# 8.66. Man-DB-2.9.4
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

# 8.67. Tar-1.34
begin tar-1.34 tar.xz
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
make -C doc install-html docdir=/usr/share/doc/tar-1.34
finish

# 8.68. Texinfo-6.7
begin texinfo-6.7 tar.xz
./configure --prefix=/usr --disable-static
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

# 8.69. Vim-8.2.2433
begin vim-8.2.2433 tar.gz
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim82/doc /usr/share/doc/vim-8.2.2433
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

# 8.70. Eudev-3.2.10
begin eudev-3.2.10 tar.gz
./configure --prefix=/usr           \
            --bindir=/sbin          \
            --sbindir=/sbin         \
            --libdir=/usr/lib       \
            --sysconfdir=/etc       \
            --libexecdir=/lib       \
            --with-rootprefix=      \
            --with-rootlibdir=/lib  \
            --enable-manpages       \
            --disable-static
make
mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
tar -xvf ../udev-lfs-20171102.tar.xz
make -f udev-lfs-20171102/Makefile.lfs install
udevadm hwdb --update
finish

# 8.71. Procps-ng-3.3.17
# This package extracts to the directory procps-3.3.17, not the expected procps-ng-3.3.17
# the tar file was renamed after d/l 
begin procps-3.3.17 tar.xz
./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng-3.3.17 \
            --disable-static                         \
            --disable-kill
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
finish

# 8.72. Util-linux-2.36.2
begin util-linux-2.36.2 tar.xz
#mkdir -pv /var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.36.2 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir \
	    runstatedir=/run
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.73. E2fsprogs-1.46.1
begin e2fsprogs-1.46.1 tar.gz
mkdir -v build
cd       build
../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
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

# 8.74. Sysklogd-1.5.1
begin sysklogd-1.5.1 tar.gz
sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
sed -i 's/union wait/int/' syslogd.c
make
make BINDIR=/sbin install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
finish

# 8.75. Sysvinit-2.98
begin sysvinit-2.98 tar.xz
patch -Np1 -i ../sysvinit-2.98-consolidated-1.patch
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.77. Stripping Again
save_lib="ld-2.33.so libc-2.33.so libpthread-2.33.so libthread_db-1.0.so"
cd /lib
for LIB in $save_lib; do
    objcopy --only-keep-debug $LIB $LIB.dbg 
    strip --strip-unneeded $LIB
    objcopy --add-gnu-debuglink=$LIB.dbg $LIB 
done    
save_usrlib="libquadmath.so.0.0.0 libstdc++.so.6.0.28
             libitm.so.1.0.0 libatomic.so.1.2.0" 
cd /usr/lib
for LIB in $save_usrlib; do
    objcopy --only-keep-debug $LIB $LIB.dbg
    strip --strip-unneeded $LIB
    objcopy --add-gnu-debuglink=$LIB.dbg $LIB
done
unset LIB save_lib save_usrlib
find /usr/lib -type f -name \*.a \
   -exec strip --strip-debug {} ';'
find /lib /usr/lib -type f -name \*.so* ! -name \*dbg \
   -exec strip --strip-unneeded {} ';'
find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
    -exec strip --strip-all {} ';'

# 8.78. Cleaning Up
rm -rf /tmp/*a

echo "lfs-system2.sh"
cat  /sources/systemrc.log

