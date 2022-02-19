#!/bin/bash
# BLFS  Build Script

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

# https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
#wget https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
begin which-2.21 tar.gz
./configure --prefix=/usr &&
make
make install;rc=$?;echo $package_name $rc >> /sources/4rc.log
finish



# https://downloads.sourceforge.net/libpng/libpng-1.6.37.tar.xz
#wget https://downloads.sourceforge.net/libpng/libpng-1.6.37.tar.xz
#wget https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-1.6.37-apng.patch.gz
begin libpng-1.6.37 tar.xz
gzip -cd ../libpng-1.6.37-apng.patch.gz | patch -p1
./configure --prefix=/usr --disable-static &&
make
make install && rc=$?;echo $package_name $rc >> /sources/4rc.log
mkdir -v /usr/share/doc/libpng-1.6.37 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.37
finish

# https://sqlite.org/2022/sqlite-autoconf-3370200.tar.gz
#wget https://sqlite.org/2022/sqlite-autoconf-3370200.tar.gz
#wget https://sqlite.org/2022/sqlite-doc-3370200.zip
begin sqlite-autoconf-3370200 tar.gz
unzip -q ../sqlite-doc-3370200.zip
./configure --prefix=/usr     \
            --disable-static  \
            --enable-fts5     \
            CPPFLAGS="-DSQLITE_ENABLE_FTS3=1            \
                      -DSQLITE_ENABLE_FTS4=1            \
                      -DSQLITE_ENABLE_COLUMN_METADATA=1 \
                      -DSQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -DSQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -DSQLITE_SECURE_DELETE=1          \
                      -DSQLITE_ENABLE_FTS3_TOKENIZER=1" &&
make
make install
install -v -m755 -d /usr/share/doc/sqlite-3.37.2 &&
cp -v -R sqlite-doc-3370200/* /usr/share/doc/sqlite-3.37.2
finish


# https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.43.tar.bz2
#wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.43.tar.bz2
begin libgpg-error-1.43 tar.bz2
./configure --prefix=/usr &&
make
make install &&
install -v -m644 -D README /usr/share/doc/libgpg-error-1.43/README
finish

# https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.9.4.tar.bz2
#wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.9.4.tar.bz2
begin libgcrypt-1.9.4 tar.bz2
./configure --prefix=/usr &&
make                      &&
make -C doc html                                                       &&
makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi &&
makeinfo --plaintext       -o doc/gcrypt.txt           doc/gcrypt.texi
make install &&
install -v -dm755   /usr/share/doc/libgcrypt-1.9.4 &&
install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
                    /usr/share/doc/libgcrypt-1.9.4 &&

install -v -dm755   /usr/share/doc/libgcrypt-1.9.4/html &&
install -v -m644 doc/gcrypt.html/* \
                    /usr/share/doc/libgcrypt-1.9.4/html &&
install -v -m644 doc/gcrypt_nochunks.html \
                    /usr/share/doc/libgcrypt-1.9.4      &&
install -v -m644 doc/gcrypt.{txt,texi} \
                    /usr/share/doc/libgcrypt-1.9.4
finish


# https://archive.mozilla.org/pub/nspr/releases/v4.33/src/nspr-4.33.tar.gz
#wget https://archive.mozilla.org/pub/nspr/releases/v4.33/src/nspr-4.33.tar.gz
begin nspr-4.33 tar.gz
cd nspr                                                     &&
sed -ri '/^RELEASE/s/^/#/' pr/src/misc/Makefile.in &&
sed -i 's#$(LIBRARY) ##'   config/rules.mk         &&
./configure --prefix=/usr \
            --with-mozilla \
            --with-pthreads \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make
make install
finish


# https://ftp.gnu.org/gnu/nettle/nettle-3.7.3.tar.gz
#wget https://ftp.gnu.org/gnu/nettle/nettle-3.7.3.tar.gz
begin nettle-3.7.3 tar.gz
./configure --prefix=/usr --disable-static &&
make
make install &&
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.7.3 &&
install -v -m644 nettle.html /usr/share/doc/nettle-3.7.3
finish


# https://archive.mozilla.org/pub/security/nss/releases/NSS_3_73_RTM/src/nss-3.74.tar.gz
#wget https://archive.mozilla.org/pub/security/nss/releases/NSS_3_73_RTM/src/nss-3.74.tar.gz
#wget https://www.linuxfromscratch.org/patches/blfs/svn/nss-3.74-standalone-1.patch
begin nss-3.74 tar.gz
patch -Np1 -i ../nss-3.74-standalone-1.patch &&
cd nss &&
make BUILD_OPT=1                  \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1) \
  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)
cd ../dist                                                          &&
install -v -m755 Linux*/lib/*.so              /usr/lib              &&
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib              &&
install -v -m755 -d                           /usr/include/nss      &&
cp -v -RL {public,private}/nss/*              /usr/include/nss      &&
chmod -v 644                                  /usr/include/nss/*    &&
install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin &&
install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig
finish

# https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.18.0.tar.gz
#wget https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.18.0.tar.gz
begin libtasn1-4.18.0 tar.gz
./configure --prefix=/usr --disable-static &&
make
make install
finish



#     https://github.com/p11-glue/p11-kit/releases/download/0.24.0/p11-kit-0.24.0.tar.xz
#wget https://github.com/p11-glue/p11-kit/releases/download/0.24.0/p11-kit-0.24.0.tar.xz
begin p11-kit-0.24.0 tar.xz
sed '20,$ d' -i trust/trust-extract-compat &&
cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications
# Generate a new trust store
/usr/sbin/make-ca -f -g
EOF
mkdir p11-build &&
cd    p11-build &&
meson --prefix=/usr       \
      --buildtype=release \
      -Dtrust_paths=/etc/pki/anchors &&
ninja
ninja install ;rc=$?;echo $package_name $rc >> /sources/4rc.log
ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates
ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
finish


# https://ftp.gnu.org/gnu/libunistring/libunistring-1.0.tar.xz
#wget https://ftp.gnu.org/gnu/libunistring/libunistring-1.0.tar.xz
begin libunistring-1.0 tar.xz
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-1.0 &&
make
make install
finish



# https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.2.tar.xz
#wget https://www.gnupg.org/ftp/gcrypt/gnutls/v3.7/gnutls-3.7.2.tar.xz
begin gnutls-3.7.2 tar.xz
./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.7.2 \
            --disable-guile \
            --disable-rpath \
            --with-default-trust-store-pkcs11="pkcs11:" &&
#	    --with-included-libtasn1 \
#	    --with-included-unistring  &&
make
make install
finish


#     https://github.com/lfs-book/make-ca/releases/download/v1.9/make-ca-1.9.tar.xz
#wget https://github.com/lfs-book/make-ca/releases/download/v1.9/make-ca-1.9.tar.xz
#wget http://www.cacert.org/certs/root.crt 
#wget http://www.cacert.org/certs/class3.crt
begin make-ca-1.9 tar.xz
#required p11-kit
make install ;rc=$?;echo $package_name $rc >> /sources/4rc.log
install -vdm755 /etc/ssl/local
/usr/sbin/make-ca -g
systemctl enable update-pki.timer
finish


#     openssh-8.8p1.tar.gz 
#wget https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.8p1.tar.gz
begin openssh-8.8p1 tar.gz
install  -v -m700 -d /var/lib/sshd &&
chown    -v root:sys /var/lib/sshd &&
groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd
./configure --prefix=/usr                            \
            --sysconfdir=/etc/ssh                    \
            --with-md5-passwords                     \
            --with-privsep-path=/var/lib/sshd        \
            --with-default-path=/usr/bin             \
            --with-superuser-path=/usr/sbin:/usr/bin \
            --with-pid-dir=/run
make
make install ;rc=$?;echo $package_name $rc >> /sources/4rc.log
install -v -m755    contrib/ssh-copy-id /usr/bin     
install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              
install -v -m755 -d /usr/share/doc/openssh-8.8p1     
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-8.8p1
finish

cd /sources/blfs-systemd-units
make install-sshd


# https://www.sudo.ws/dist/sudo-1.9.8p2.tar.gz
#wget https://www.sudo.ws/dist/sudo-1.9.8p2.tar.gz
begin sudo-1.9.8p2 tar.gz
./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.9.8p2 \
            --with-passprompt="[sudo] password for %p: " &&
make
make install ;rc=$?;echo $package_name $rc >> /sources/4rc.log
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
finish
cat > /etc/sudoers.d/sudo << "EOF"
Defaults secure_path="/usr/bin:/bin:/usr/sbin:/sbin"
%wheel ALL=(ALL) ALL
paul    ALL=(ALL:ALL)   NOPASSWD:ALL
ansible ALL=(ALL:ALL)   NOPASSWD:ALL
EOF


#  https://github.com/linux-pam/linux-pam/releases/download/v1.5.2/Linux-PAM-1.5.2.tar.xz
#wget https://github.com/linux-pam/linux-pam/releases/download/v1.5.2/Linux-PAM-1.5.2-docs.tar.xz
#wget https://github.com/linux-pam/linux-pam/releases/download/v1.5.2/Linux-PAM-1.5.2.tar.xz
begin Linux-PAM-1.5.2 tar.xz
tar -xf ../Linux-PAM-1.5.2-docs.tar.xz --strip-components=1
./configure --prefix=/usr                        \
            --sbindir=/usr/sbin                  \
            --sysconfdir=/etc                    \
            --libdir=/usr/lib                    \
            --enable-securedir=/usr/lib/security \
            --docdir=/usr/share/doc/Linux-PAM-1.5.2 &&
make
install -v -m755 -d /etc/pam.d &&
make install &&
chmod -v 4755 /usr/sbin/unix_chkpwd
install -vdm755 /etc/pam.d &&
finish

cat > /etc/pam.d/system-account << "EOF" &&
# Begin /etc/pam.d/system-account

account   required    pam_unix.so

# End /etc/pam.d/system-account
EOF

cat > /etc/pam.d/system-auth << "EOF" &&
# Begin /etc/pam.d/system-auth

auth      required    pam_unix.so

# End /etc/pam.d/system-auth
EOF

cat > /etc/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session

session   required    pam_unix.so

# End /etc/pam.d/system-session
EOF
cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# use sha512 hash for encryption, use shadow, and try to use any previously
# defined authentication token (chosen password) set by any prior module
password  required    pam_unix.so       sha512 shadow try_first_pass

# End /etc/pam.d/system-password
EOF

cat > /etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth        required        pam_warn.so
auth        required        pam_deny.so
account     required        pam_warn.so
account     required        pam_deny.so
password    required        pam_warn.so
password    required        pam_deny.so
session     required        pam_warn.so
session     required        pam_deny.so

# End /etc/pam.d/other
EOF

# 8.25.reinstall Shadow-4.11.1
begin shadow-4.11.1 tar.xz
sed -i.orig '/$(LIBTCB)/i $(LIBPAM) \\' libsubid/Makefile.am &&
sed -i "224s/rounds/min_rounds/"        libmisc/salt.c       &&
autoreconf -fiv &&
sed -i 's/groups$(EXEEXT) //' src/Makefile.in &&
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \; &&
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \; &&
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \; &&
sed -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
    -e 's@/var/spool/mail@/var/mail@'                 \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                \
    -i etc/login.defs                                 &&
./configure --sysconfdir=/etc --with-group-name-max-length=32 &&
make
make exec_prefix=/usr install;rc=$?;echo $package_name $rc >> /sources/systemrc.log
finish

install -v -m644 /etc/login.defs /etc/login.defs.orig &&
for FUNCTION in FAIL_DELAY               \
                FAILLOG_ENAB             \
                LASTLOG_ENAB             \
                MAIL_CHECK_ENAB          \
                OBSCURE_CHECKS_ENAB      \
                PORTTIME_CHECKS_ENAB     \
                QUOTAS_ENAB              \
                CONSOLE MOTD_FILE        \
                FTMP_FILE NOLOGINS_FILE  \
                ENV_HZ PASS_MIN_LEN      \
                SU_WHEEL_ONLY            \
                CRACKLIB_DICTPATH        \
                PASS_CHANGE_TRIES        \
                PASS_ALWAYS_WARN         \
                CHFN_AUTH ENCRYPT_METHOD \
                ENVIRON_FILE
do
    sed -i "s/^${FUNCTION}/# &/" /etc/login.defs
done

cat > /etc/pam.d/login << "EOF"
# Begin /etc/pam.d/login

# Set failure delay before next prompt to 3 seconds
auth      optional    pam_faildelay.so  delay=3000000

# Check to make sure that the user is allowed to login
auth      requisite   pam_nologin.so

# Check to make sure that root is allowed to login
# Disabled by default. You will need to create /etc/securetty
# file for this module to function. See man 5 securetty.
#auth      required    pam_securetty.so

# Additional group memberships - disabled by default
#auth      optional    pam_group.so

# include system auth settings
auth      include     system-auth

# check access for the user
account   required    pam_access.so

# include system account settings
account   include     system-account

# Set default environment variables for the user
session   required    pam_env.so

# Set resource limits for the user
session   required    pam_limits.so

# Display date of last login - Disabled by default
#session   optional    pam_lastlog.so

# Display the message of the day - Disabled by default
#session   optional    pam_motd.so

# Check user's mail - Disabled by default
#session   optional    pam_mail.so      standard quiet

# include system session and password settings
session   include     system-session
password  include     system-password

# End /etc/pam.d/login
EOF

cat > /etc/pam.d/passwd << "EOF"
# Begin /etc/pam.d/passwd

password  include     system-password

# End /etc/pam.d/passwd
EOF

cat > /etc/pam.d/su << "EOF"
# Begin /etc/pam.d/su

# always allow root
auth      sufficient  pam_rootok.so

# Allow users in the wheel group to execute su without a password
# disabled by default
#auth      sufficient  pam_wheel.so trust use_uid

# include system auth settings
auth      include     system-auth

# limit su to users in the wheel group
auth      required    pam_wheel.so use_uid

# include system account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session settings
session   include     system-session

# End /etc/pam.d/su
EOF

cat > /etc/pam.d/chage << "EOF"
# Begin /etc/pam.d/chage

# always allow root
auth      sufficient  pam_rootok.so

# include system auth, account, and session settings
auth      include     system-auth
account   include     system-account
session   include     system-session

# Always permit for authentication updates
password  required    pam_permit.so

# End /etc/pam.d/chage
EOF

for PROGRAM in chfn chgpasswd chpasswd chsh groupadd groupdel \
               groupmems groupmod newusers useradd userdel usermod
do
    install -v -m644 /etc/pam.d/chage /etc/pam.d/${PROGRAM}
    sed -i "s/chage/$PROGRAM/" /etc/pam.d/${PROGRAM}
done

[ -f /etc/login.access ] && mv -v /etc/login.access{,.NOUSE}
[ -f /etc/limits ] && mv -v /etc/limits{,.NOUSE}




cat > /etc/profile.d/xorg.sh << EOF
XORG_PREFIX="$XORG_PREFIX"
XORG_CONFIG="--prefix=\$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
export XORG_PREFIX XORG_CONFIG
EOF
chmod 644 /etc/profile.d/xorg.sh


# https://github.com/systemd/systemd/archive/v249/systemd-250.tar.gz
cd /sources
begin systemd-250 tar.gz
patch -Np1 -i ../systemd-250-upstream_fixes-1.patch
sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in
sed -i 's/+ want_libfuzzer.*$/and want_libfuzzer/' meson.build
sed -i '/ARPHRD_CAN/a#define ARPHRD_MCTP        290' src/basic/linux/if_arp.h
mkdir build &&
cd    build &&
meson --prefix=/usr                 \
      --buildtype=release           \
      -Dblkid=true                  \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dman=auto                    \
      -Dsysusers=false              \
      -Drpmmacrosdir=no             \
      -Db_lto=false                 \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dmode=release                \
      -Dpamconfdir=/etc/pam.d       \
      -Ddocdir=/usr/share/doc/systemd-250 \
      ..                            &&
ninja
ninja install
finish

cat >> /etc/pam.d/system-session << "EOF"
# Begin Systemd addition

session  required    pam_loginuid.so
session  optional    pam_systemd.so

# End Systemd addition
EOF

cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user

account  required    pam_access.so
account  include     system-account

session  required    pam_env.so
session  required    pam_limits.so
session  required    pam_unix.so
session  required    pam_loginuid.so
session  optional    pam_keyinit.so force revoke
session  optional    pam_systemd.so

auth     required    pam_deny.so
password required    pam_deny.so

# End /etc/pam.d/systemd-user
EOF




#  Cleaning Up
rm -rf /tmp/*a

echo "blfs-4.sh"
cat  /sources/4rc.log

