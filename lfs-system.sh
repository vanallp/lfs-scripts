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

# 8.3. Man-pages-5.10
begin man-pages-5.10 tar.xz
make install ;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.4. Iana-Etc-20210202
begin iana-etc-20210202 tar.gz
cp services protocols /etc ;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.5. Glibc-2.33
begin glibc-2.33 tar.xz
patch -Np1 -i ../glibc-2.33-fhs-1.patch
sed -e '402a\      *result = local->data.services[database_index];' \
    -i nss/nss_database.c
mkdir -v build
cd       build
../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/lib
make
#case $(uname -m) in
#  i?86)   ln -sfnv $PWD/elf/ld-linux.so.2        /lib ;;
#  x86_64) ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib ;;
#esac
touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd
mkdir -pv /usr/lib/locale
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f SHIFT_JIS ja_JP.SIJS 2> /dev/null || true
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
tar -xf ../../tzdata2021a.tar.gz
ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done
cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO
ln -sfv /usr/share/zoneinfo/America/New_York /etc/localtime
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d
finish

# 8.6. Zlib-1.2.11
begin zlib-1.2.11 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
rm -fv /usr/lib/libz.a
finish

# 8.7. Bzip2-1.0.8
begin bzip2-1.0.8 tar.gz
patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat
rm -fv /usr/lib/libbz2.a
finish

# 8.8. Xz-5.2.5
begin xz-5.2.5 tar.xz
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.5
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
finish

# 8.9. Zstd-1.4.8
begin zstd-1.4.8 tar.gz
make
make prefix=/usr install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
rm -v /usr/lib/libzstd.a
mv -v /usr/lib/libzstd.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libzstd.so) /usr/lib/libzstd.so
finish

# 8.10. File-5.39
begin file-5.39 tar.gz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.11. Readline-8.1
begin readline-8.1 tar.gz
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.1
make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/lib/lib{readline,history}.so.* /lib
## chmod -v u+w /lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.1
finish

# 8.12. M4-1.4.18
begin m4-1.4.18 tar.xz
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.13. Bc-3.3.0
begin bc-3.3.0 tar.xz
#PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3
PREFIX=/usr CC=gcc  ./configure.sh -G -O3
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish
 
## 8.14. Flex-2.6.4
begin flex-2.6.4 tar.gz
./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
ln -sv flex /usr/bin/lex
finish


# 8.15. Tcl-8.6.11
begin tcl8.6.11 tar.gz
tar -xf ../tcl8.6.11-html.tar.gz --strip-components=1
SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ "$(uname -m)" = x86_64 ] && echo --enable-64bit)
make
sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh
sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.2|/usr/lib/tdbc1.1.2|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.2/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.2/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.2|/usr/include|"            \
    -i pkgs/tdbc1.1.1/tdbcConfig.sh
sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.1|/usr/lib/itcl4.2.1|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.1/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.2.1|/usr/include|"            \
    -i pkgs/itcl4.2.1/itclConfig.sh
unset SRCDIR
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
chmod -v u+w /usr/lib/libtcl8.6.so
make install-private-headers
ln -sfv tclsh8.6 /usr/bin/tclsh
mv /usr/share/man/man3/{Thread,Tcl_Thread}.3
finish

# 8.16. Expect-5.45.4
begin expect5.45.4 tar.gz
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
finish

# 8.17. DejaGNU-1.6.2
begin dejagnu-1.6.2 tar.gz
./configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -v -dm755  /usr/share/doc/dejagnu-1.6.2
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.2
finish

# 8.18. Binutils-2.36.1
begin binutils-2.36.1 tar.xz
sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in
mkdir -v build
cd       build
../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib
make tooldir=/usr
make tooldir=/usr install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a
finish

# 8.19. GMP-6.2.1
begin gmp-6.2.1 tar.xz
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.2.1
make
make html
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
make install-html
finish

# 8.20. MPFR-4.1.0
begin mpfr-4.1.0 tar.xz
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.1.0
make
make html
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
make install-html
finish

# 8.21. MPC-1.2.1
begin mpc-1.2.1 tar.gz
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.2.1
make
make html
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
make install-html
finish

# 8.22. Attr-2.4.48
begin attr-2.4.48 tar.gz
./configure --prefix=/usr     \
            --bindir=/bin     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
finish

# 8.23. Acl-2.2.53
begin acl-2.2.53 tar.gz
./configure --prefix=/usr         \
            --bindir=/bin         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl-2.2.53
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
finish

# 8.24. Libcap-2.48
begin libcap-2.48 tar.xz
sed -i '/install -m.*STACAPLIBNAME/d' libcap/Makefile
make prefix=/usr lib=lib
make test
make prefix=/usr lib=lib install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
for libname in cap psx; do
    mv -v /usr/lib/lib${libname}.so.* /lib
    ln -sfv ../../lib/lib${libname}.so.2 /usr/lib/lib${libname}.so
    chmod -v 755 /lib/lib${libname}.so.2.48
done
finish

# 8.25. Shadow-4.8.1
begin shadow-4.8.1 tar.xz
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD SHA512:' \
    -e 's:/var/spool/mail:/var/mail:'                 \
    -i etc/login.defs
sed -i 's/1000/999/' etc/useradd
touch /usr/bin/passwd
./configure --sysconfdir=/etc \
            --with-group-name-max-length=32
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
pwconv
grpconv
echo "root" | passwd --stdin root
finish

# 8.26. GCC-10.2.0
begin gcc-10.2.0 tar.xz
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
mkdir -v build
cd       build
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
rm -rf /usr/lib/gcc/$(gcc -dumpmachine)/10.2.0/include-fixed/bits/
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/10.2.0/include{,-fixed}
ln -sv ../usr/bin/cpp /lib
#install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/10.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
grep -B4 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v dummy.c a.out dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
finish

# 8.27. Pkg-config-0.29.2
begin pkg-config-0.29.2 tar.gz
./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.28. Ncurses-6.2
begin ncurses-6.2 tar.gz
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/lib/libncursesw.so.6* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done
rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so
mkdir -v       /usr/share/doc/ncurses-6.2
cp -v -R doc/* /usr/share/doc/ncurses-6.2

finish

# 8.29. Sed-4.8
begin sed-4.8 tar.xz
./configure --prefix=/usr --bindir=/bin
make
make html
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
install -d -m755           /usr/share/doc/sed-4.8
install -m644 doc/sed.html /usr/share/doc/sed-4.8
finish

# 8.30. Psmisc-23.4
begin psmisc-23.4 tar.xz
./configure --prefix=/usr
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin
finish

# 8.31. Gettext-0.21
begin gettext-0.21 tar.xz
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.21
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
chmod -v 0755 /usr/lib/preloadable_libintl.so
finish

# 8.32. Bison-3.7.5
begin bison-3.7.5 tar.xz
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.7.5
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.33. Grep-3.6
begin grep-3.6 tar.xz
./configure --prefix=/usr --bindir=/bin
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

# 8.34. Bash-5.1
begin bash-5.1 tar.gz
sed -i  '/^bashline.o:.*shmbchar.h/a bashline.o: ${DEFDIR}/builtext.h' Makefile.in
./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.1 \
            --without-bash-malloc            \
            --with-installed-readline
make
make install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
mv -vf /usr/bin/bash /bin
finish

cat /sources/systemrc.log

exit



# 8.35. Libtool-2.4.6
begin libtool-2.4.6 tar.xz
./configure --prefix=/usr
make
make install
finish

# 8.36. GDBM-1.18.1
begin gdbm-1.18.1 tar.gz
sed -r -i '/^char.*parseopt_program_(doc|args)/d' src/parseopt.c
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make install
finish

# 8.37. Gperf-3.1
begin gperf-3.1 tar.gz
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
make install
finish

# 8.38. Expat-2.4.1
begin expat-2.4.1 tar.xz
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.4.1
make
make install
finish

# 8.39. Inetutils-1.9.4
begin inetutils-1.9.4 tar.xz
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
make install
mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin
finish

# 8.40. Perl-5.32.0
begin perl-5.32.0 tar.xz
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
make install
unset BUILD_ZLIB BUILD_BZIP2
finish

# 8.41. XML::Parser-2.46
begin XML-Parser-2.46 tar.gz
perl Makefile.PL
make
make install
finish

# 8.42. Intltool-0.51.0
begin intltool-0.51.0 tar.gz
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
finish

# 8.43. Autoconf-2.69
begin autoconf-2.69 tar.xz
sed -i '361 s/{/\\{/' bin/autoscan.in
./configure --prefix=/usr
make
make install
finish

# 8.44. Automake-1.16.2
begin automake-1.16.2 tar.xz
sed -i "s/''/etags/" t/tags-lisp-space.sh
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.2
make
make install
finish

# 8.45. Kmod-27
begin kmod-27 tar.xz
./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zlib
make
make install
for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done
ln -sfv kmod /bin/lsmod
finish

# 8.46. Libelf from Elfutils-0.180
begin elfutils-0.180 tar.bz2
./configure --prefix=/usr --disable-debuginfod --libdir=/lib
make
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /lib/libelf.a
finish

# 8.47. Libffi-3.3
begin libffi-3.3 tar.gz
./configure --prefix=/usr --disable-static --with-gcc-arch=native
make
make install
finish

# 8.48. OpenSSL-1.1.1g
begin openssl-1.1.1g tar.gz
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1g
cp -vfr doc/* /usr/share/doc/openssl-1.1.1g
finish

# 8.49. Python-3.8.5
begin Python-3.8.5 tar.xz
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes
make
make install
chmod -v 755 /usr/lib/libpython3.8.so
chmod -v 755 /usr/lib/libpython3.so
ln -sfv pip3.8 /usr/bin/pip3
install -v -dm755 /usr/share/doc/python-3.8.5/html 
tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.8.5/html \
    -xvf ../python-3.8.5-docs-html.tar.bz2
finish

# 8.50. Ninja-1.10.0
begin ninja-1.10.0 tar.gz
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc
python3 configure.py --bootstrap
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
finish

# 8.51. Meson-0.55.0
begin meson-0.55.0 tar.gz
python3 setup.py build
python3 setup.py install --root=dest
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
make install
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
make docdir=/usr/share/doc/check-0.15.2 install
finish

# 8.54. Diffutils-3.7
begin diffutils-3.7 tar.xz
./configure --prefix=/usr
make
make install
finish

# 8.55. Gawk-5.1.0
begin gawk-5.1.0 tar.xz
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make install
mkdir -v /usr/share/doc/gawk-5.1.0
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.0
finish

# 8.56. Findutils-4.7.0
begin findutils-4.7.0 tar.xz
./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make install
mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
finish

# 8.57. Groff-1.22.4
begin groff-1.22.4 tar.gz
PAGE=A4 ./configure --prefix=/usr
make -j1
make install
finish

# 8.58. GRUB-2.04
begin grub-2.04 tar.xz
unset {C,CXX,LD}FLAGS
./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --enable-grub-mkfont   \
            --with-platform=efi    \
            --disable-werror
make
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
finish

# 8.59. Less-551
begin less-551 tar.gz
./configure --prefix=/usr --sysconfdir=/etc
make
make install
finish

# 8.60. Gzip-1.10
begin gzip-1.10 tar.xz
./configure --prefix=/usr
make
make install
mv -v /usr/bin/gzip /bin
finish

# 8.61. IPRoute2-5.8.0
begin iproute2-5.8.0 tar.xz
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
sed -i 's/.m_ipt.o//' tc/Makefile
make
make DOCDIR=/usr/share/doc/iproute2-5.8.0 install
finish

# 8.62. Kbd-2.3.0
begin kbd-2.3.0 tar.xz
patch -Np1 -i ../kbd-2.3.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make install
rm -v /usr/lib/libtswrap.{a,la,so*}
mkdir -v            /usr/share/doc/kbd-2.3.0
cp -R -v docs/doc/* /usr/share/doc/kbd-2.3.0
finish

# 8.63. Libpipeline-1.5.3
begin libpipeline-1.5.3 tar.gz
./configure --prefix=/usr
make
make install
finish

# 8.64. Make-4.3
begin make-4.3 tar.gz
./configure --prefix=/usr
make
make install
finish

# 8.65. Patch-2.7.6
begin patch-2.7.6 tar.x
./configure --prefix=/usr
make
make install
finish

# 8.66. Man-DB-2.9.3
begin man-db-2.9.3 tar.xz
./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.9.3 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap            \
            --with-systemdtmpfilesdir=           \
            --with-systemdsystemunitdir=
make
make install
finish

# 8.67. Tar-1.32
begin tar-1.32 tar.xz
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin
make
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.32
finish

# 8.68. Texinfo-6.7
begin texinfo-6.7 tar.xz
./configure --prefix=/usr --disable-static
make
make install
make TEXMF=/usr/share/texmf install-tex
pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd
finish

# 8.69. mv vim-8.2.3043
begin vim-8.2.3043 tar.gz
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make
make install
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim82/doc /usr/share/doc/vim-8.2.1361
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

# 8.70. Eudev-3.2.9
begin eudev-3.2.9 tar.gz
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
make install
tar -xvf ../udev-lfs-20171102.tar.xz
make -f udev-lfs-20171102/Makefile.lfs install
udevadm hwdb --update
finish

# 8.71. Procps-ng-3.3.16
begin procps-ng-3.3.16 tar.xz
./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng-3.3.16 \
            --disable-static                         \
            --disable-kill
make
make install
mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
finish

# 8.72. Util-linux-2.36
begin util-linux-2.36 tar.xz
mkdir -pv /var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.36 \
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
            --without-systemdsystemunitdir
make
make install
finish

# 8.73. E2fsprogs-1.45.6
begin e2fsprogs-1.45.6 tar.gz
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
make install
chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
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
make BINDIR=/sbin install
finish

# 8.75. Sysvinit-2.97
begin sysvinit-2.97 tar.xz
patch -Np1 -i ../sysvinit-2.97-consolidated-1.patch
make
make install
finish

# 8.77. Stripping Again
save_lib="ld-2.32.so libc-2.32.so libpthread-2.32.so libthread_db-1.0.so"
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
rm -rf /tmp/*
