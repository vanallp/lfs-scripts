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


# 
wget https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.6p1.tar.gz

begin openssh-8.6p1 tar.gz
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
make install ;rc=$?;echo $package_name $rc >> /sources/blfssecurityrc.log
install -v -m755    contrib/ssh-copy-id /usr/bin     

install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              
install -v -m755 -d /usr/share/doc/openssh-8.6p1     
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-8.6p1
finish

make install-sshd

# https://www.sudo.ws/dist/sudo-1.9.7p1.tar.gz
wget https://www.sudo.ws/dist/sudo-1.9.7p1.tar.gz
begin sudo-1.9.7p1 tar.gz
./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.9.7p1 \
            --with-passprompt="[sudo] password for %p: " &&
make
make install ;rc=$?;echo $package_name $rc >> /sources/blfssecurityrc.log
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
finish
cat > /etc/sudoers.d/sudo << "EOF"
Defaults secure_path="/usr/bin:/bin:/usr/sbin:/sbin"
%wheel ALL=(ALL) ALL
paul    ALL=(ALL:ALL)   NOPASSWD:ALL
ansible ALL=(ALL:ALL)   NOPASSWD:ALL
EOF


# https://ftp.gnu.org/gnu/parted/parted-3.4.tar.xz
wget https://ftp.gnu.org/gnu/parted/parted-3.4.tar.xz
begin parted-3.4 tar.xz
./configure --prefix=/usr --disable-static 
make 

make -C doc html                                       
makeinfo --html      -o doc/html       doc/parted.texi 
makeinfo --plaintext -o doc/parted.txt doc/parted.texi

make install ;rc=$?;echo $package_name $rc >> /sources/blfssecurityrc.log
install -v -m755 -d /usr/share/doc/parted-3.4/html 
install -v -m644    doc/html/* \
                    /usr/share/doc/parted-3.4/html 
install -v -m644    doc/{FAT,API,parted.{txt,html}} \
                    /usr/share/doc/parted-3.4

install -v -m644 doc/FAT doc/API doc/parted.{pdf,ps,dvi} \
                    /usr/share/doc/parted-3.4
finish


#  Cleaning Up
rm -rf /tmp/*a

echo "blfs-security.sh"
cat  /sources/blfssecurityrc.log

