#!/bin/bash -e
# BLFS r11 sept 24th updates Build Script

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

# https://downloads.sourceforge.net/lxde/lxmenu-data-0.1.5.tar.xz
wget --no-check-certificate https://downloads.sourceforge.net/lxde/lxmenu-data-0.1.5.tar.xz
begin lxmenu-data-0.1.5 tar.xz
./configure --prefix=/usr --sysconfdir=/etc &&
make
sudo make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz
wget http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz
begin libxml2-2.9.12 tar.gz
./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3 &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# http://xmlsoft.org/sources/libxslt-1.1.34.tar.gz
wget http://xmlsoft.org/sources/libxslt-1.1.34.tar.gz
begin libxslt-1.1.34 tar.gz
sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml} &&
sed -i -r '/max(Parser)?Depth/d' ./tests/fuzz/fuzz.c &&
./configure --prefix=/usr --disable-static --without-python  &&
make
sudo make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://dist.libuv.org/dist/v1.42.0/libuv-v1.42.0.tar.gz
wget --no-check-certificate https://dist.libuv.org/dist/v1.42.0/libuv-v1.42.0.tar.gz
begin libuv-v1.42.0 tar.gz
sh autogen.sh                              &&
./configure --prefix=/usr --disable-static &&
make 
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz
wget --no-check-certificate https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz
begin lzo-2.10 tar.gz
./configure --prefix=/usr                    \
            --enable-shared                  \
            --disable-static                 \
            --docdir=/usr/share/doc/lzo-2.10 &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://ftp.gnu.org/gnu/nettle/nettle-3.7.3.tar.gz
wget --no-check-certificate https://ftp.gnu.org/gnu/nettle/nettle-3.7.3.tar.gz
begin nettle-3.7.3 tar.gz
./configure --prefix=/usr --disable-static &&
make
sudo make install && rc=$?;echo $package_name $rc >> /sources/37rc.log
sudo chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
sudo install -v -m755 -d /usr/share/doc/nettle-3.7.3 &&
sudo install -v -m644 nettle.html /usr/share/doc/nettle-3.7.3
finish


# https://github.com/libarchive/libarchive/releases/download/v3.5.2/libarchive-3.5.2.tar.xz
wget --no-check-certificate  https://github.com/libarchive/libarchive/releases/download/v3.5.2/libarchive-3.5.2.tar.xz
begin libarchive-3.5.2 tar.xz
./configure --prefix=/usr --disable-static &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://curl.se/download/curl-7.79.1.tar.xz
wget --no-check-certificate  https://curl.se/download/curl-7.79.1.tar.xz
begin curl-7.79.1 tar.xz
grep -rl '#!.*python$' | xargs sed -i '1s/python/&3/'
./configure --prefix=/usr                           \
            --disable-static                        \
            --with-openssl                          \
            --enable-threaded-resolver              \
            --with-ca-path=/etc/ssl/certs &&
make
sudo make install && rc=$?;echo $package_name $rc >> /sources/37rc.log
sudo rm -rf docs/examples/.deps &&
sudo find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&
sudo install -v -d -m755 /usr/share/doc/curl-7.79.1 &&
sudo cp -v -R docs/*     /usr/share/doc/curl-7.79.1
finish



# https://cmake.org/files/v3.21/cmake-3.21.3.tar.gz
wget --no-check-certificate https://cmake.org/files/v3.21/cmake-3.21.3.tar.gz
begin cmake-3.21.3 tar.gz
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --docdir=/share/doc/cmake-3.21.3 &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.xz
wget --no-check-certificate https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.xz
begin nasm-2.15.05 tar.xz
./configure --prefix=/usr &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-2.1.1.tar.gz
wget --no-check-certificate https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-2.1.1.tar.gz
begin libjpeg-turbo-2.1.1 tar.gz
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=RELEASE  \
      -DENABLE_STATIC=FALSE       \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-2.1.1 \
      -DCMAKE_INSTALL_DEFAULT_LIBDIR=lib  \
      .. &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz
wget http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz
begin libxml2-2.9.12 tar.gz
./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3 &&
make
sudo make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
wget --no-check-certificate https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/11.0/sgml-common-0.6.3-manpage-1.patch
begin sgml-common-0.6.3 tgz
patch -Np1 -i ../sgml-common-0.6.3-manpage-1.patch &&
autoreconf -f -i
./configure --prefix=/usr --sysconfdir=/etc &&
make
sudo make docdir=/usr/share/doc install && rc=$?;echo $package_name $rc >> /sources/37rc.log
sudo install-catalog --add /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&
sudo install-catalog --add /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat
finish


# https://downloads.sourceforge.net/infozip/unzip60.tar.gz
wget --no-check-certificate https://downloads.sourceforge.net/infozip/unzip60.tar.gz
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/11.0/unzip-6.0-consolidated_fixes-1.patch
begin unzip60 tar.gz
patch -Np1 -i ../unzip-6.0-consolidated_fixes-1.patch
make -f unix/Makefile generic
sudo make prefix=/usr MANDIR=/usr/share/man/man1 \
 -f unix/Makefile install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish
  

# https://www.docbook.org/xml/4.5/docbook-xml-4.5.zip
wget --no-check-certificate https://www.docbook.org/xml/4.5/docbook-xml-4.5.zip
mkdir /sources/docbook-xml-4.5
cd    /sources/docbook-xml-4.5
unzip ../docbook-xml-4.5.zip
sudo install -v -d -m755 /usr/share/xml/docbook/xml-dtd-4.5 &&
sudo install -v -d -m755 /etc/xml &&
sudo chown -R root:root . &&
sudo cp -v -af docbook.cat *.dtd ent/ *.mod \
    /usr/share/xml/docbook/xml-dtd-4.5
if [ ! -e /etc/xml/docbook ]; then
    sudo xmlcatalog --noout --create /etc/xml/docbook
fi &&
sudo xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V4.5//EN" \
    "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML CALS Table Model V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/calstblx.dtd" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "public" \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/soextblx.dtd" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Information Pool V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbpoolx.mod" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbhierx.mod" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/htmltblx.mod" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Notations V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbnotnx.mod" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Character Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbcentx.mod" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbgenent.mod" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook &&
sudo xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
if [ ! -e /etc/xml/catalog ]; then
    sudo xmlcatalog --noout --create /etc/xml/catalog
fi &&
sudo xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//ENTITIES DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
sudo xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//DTD DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
sudo xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
sudo xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog

for DTDVERSION in 4.1.2 4.2 4.3 4.4
do
  sudo xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V$DTDVERSION//EN" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/docbookx.dtd" \
    /etc/xml/docbook
  sudo xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
  sudo xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
  sudo xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
  sudo xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
done
cd /sources
rm -rf docbook-xml-4.5


# http://files.itstool.org/itstool/itstool-2.0.7.tar.bz2
wget --no-check-certificate http://files.itstool.org/itstool/itstool-2.0.7.tar.bz2
begin itstool-2.0.7 tar.bz2
PYTHON=/usr/bin/python3 ./configure --prefix=/usr &&
make
sudo make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-nons-1.79.2.tar.bz2
wget --no-check-certificate https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-nons-1.79.2.tar.bz2
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/11.0/docbook-xsl-nons-1.79.2-stack_fix-1.patch
begin docbook-xsl-nons-1.79.2 tar.bz2
patch -Np1 -i ../docbook-xsl-nons-1.79.2-stack_fix-1.patch
sudo install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 &&
sudo cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
         highlighting html htmlhelp images javahelp lib manpages params  \
         profiling roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 xhtml5                                          \
    /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 &&
sudo ln -s VERSION /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2/VERSION.xsl &&
sudo install -v -m644 -D README \
                    /usr/share/doc/docbook-xsl-nons-1.79.2/README.txt &&
sudo install -v -m644    RELEASE-NOTES* NEWS* \
                    /usr/share/doc/docbook-xsl-nons-1.79.2
if [ ! -d /etc/xml ]; then sudo install -v -m755 -d /etc/xml; fi &&
if [ ! -f /etc/xml/catalog ]; then
    sudo xmlcatalog --noout --create /etc/xml/catalog
fi &&

sudo xmlcatalog --noout --add "rewriteSystem" \
           "https://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

sudo xmlcatalog --noout --add "rewriteURI" \
           "https://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

sudo xmlcatalog --noout --add "rewriteSystem" \
           "https://cdn.docbook.org/release/xsl-nons/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

sudo xmlcatalog --noout --add "rewriteURI" \
           "https://cdn.docbook.org/release/xsl-nons/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

sudo xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

sudo xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog
finish



# https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2
wget --no-check-certificate https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2
begin xmlto-0.0.28 tar.bz2
LINKS="/usr/bin/links" \
./configure --prefix=/usr &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish

# Run-time dependency libpcre found: NO 
# https://sourceware.org/ftp/valgrind/valgrind-3.17.0.tar.bz2
wget --no-check-certificate  https://www.linuxfromscratch.org/patches/blfs/svn/valgrind-3.17.0-upstream_fixes-1.patch
wget --no-check-certificate  https://sourceware.org/ftp/valgrind/valgrind-3.17.0.tar.bz2
begin valgrind-3.17.0 tar.bz2
patch -Np1 -i ../valgrind-3.17.0-upstream_fixes-1.patch
autoreconf -fiv &&
sed -i 's|/doc/valgrind||' docs/Makefile.in &&
./configure --prefix=/usr \
            --datadir=/usr/share/doc/valgrind-3.17.0 &&
make
sudo make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish

# https://ftp.pcre.org/pub/pcre/pcre-8.45.tar.bz2
wget --no-check-certificate  https://ftp.pcre.org/pub/pcre/pcre-8.45.tar.bz2
begin pcre-8.45 tar.bz2
./configure --prefix=/usr                     \
            --docdir=/usr/share/doc/pcre-8.45 \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static                 &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish



# https://download.gnome.org/sources/glib/2.70/glib-2.70.0.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/glib/2.70/glib-2.70.0.tar.xz
begin glib-2.70.0 tar.xz
mkdir build &&
cd    build &&

meson --prefix=/usr       \
      --buildtype=release \
      -Dman=true          \
      ..                  &&
ninja
sudo ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
sudo mkdir -p /usr/share/doc/glib-2.70.0 &&
sudo cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.70.0
finish


# https://downloads.sourceforge.net/pcmanfm/libfm-1.3.2.tar.xz
wget --no-check-certificate https://downloads.sourceforge.net/pcmanfm/libfm-1.3.2.tar.xz
begin libfm-1.3.2 tar.xz
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-extra-only \
            --with-gtk=no     \
            --disable-static  &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish

# https://downloads.sourceforge.net/lxde/menu-cache-1.1.0.tar.xz
# https://www.linuxfromscratch.org/patches/blfs/11.0/menu-cache-1.1.0-consolidated_fixes-1.patch
wget --no-check-certificate https://downloads.sourceforge.net/lxde/menu-cache-1.1.0.tar.xz
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/11.0/menu-cache-1.1.0-consolidated_fixes-1.patch
begin menu-cache-1.1.0 tar.xz
patch -Np1 -i ../menu-cache-1.1.0-consolidated_fixes-1.patch
./configure --prefix=/usr    \
            --disable-static &&
make
sudo make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/gobject-introspection/1.70/gobject-introspection-1.70.0.tar.xz
wget --no-check-certificate  https://download.gnome.org/sources/gobject-introspection/1.70/gobject-introspection-1.70.0.tar.xz
begin gobject-introspection-1.70.0 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release .. &&
ninja
sudo ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish



# https://download.gnome.org/sources/atk/2.36/atk-2.36.0.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/atk/2.36/atk-2.36.0.tar.xz
begin atk-2.36.0 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release .. &&
ninja
sudo ninja install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish 

# https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.1/shared-mime-info-2.1.tar.gz
wget --no-check-certificate https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.1/shared-mime-info-2.1.tar.gz
begin shared-mime-info-2.1 tar.gz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release -Dupdate-mimedb=true .. &&
ninja
sudo ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
begin gdk-pixbuf-2.42.6 tar.xz
mkdir build &&
cd build &&
meson --prefix=/usr --buildtype=release --wrap-mode=nofallback .. &&
ninja
sudo ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
wget --no-check-certificate https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
begin which-2.21 tar.gz
./configure --prefix=/usr &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz
wget --no-check-certificate  https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz
begin graphite2-1.3.14 tgz
sed -i '/cmptest/d' tests/CMakeLists.txt
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make
make docs
sudo make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
sudo install -v -d -m755 /usr/share/doc/graphite2-1.3.14 &&
sudo cp      -v -f    doc/{GTF,manual}.html \
                    /usr/share/doc/graphite2-1.3.14 &&
sudo cp      -v -f    doc/{GTF,manual}.pdf \
                    /usr/share/doc/graphite2-1.3.14
finish


# https://www.cairographics.org/releases/pixman-0.40.0.tar.gz
wget --no-check-certificate  https://www.cairographics.org/releases/pixman-0.40.0.tar.gz
begin pixman-0.40.0 tar.gz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release &&
ninja
sudo ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://www.cairographics.org/snapshots/cairo-1.17.4.tar.xz
wget --no-check-certificate  https://www.cairographics.org/snapshots/cairo-1.17.4.tar.xz
begin cairo-1.17.4 tar.xz
./configure --prefix=/usr    \
            --disable-static \
            --enable-tee &&
make
sudo make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish
# There is a circular dependency between cairo and harfbuzz. If cairo is built before harfbuzz, it is necessary to rebuild cairo after harfbuzz in order to build pango.


# https://github.com/harfbuzz/harfbuzz/releases/download/3.0.0/harfbuzz-3.0.0.tar.xz
wget --no-check-certificate https://github.com/harfbuzz/harfbuzz/releases/download/3.0.0/harfbuzz-3.0.0.tar.xz
begin harfbuzz-3.0.0 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr        \
      --buildtype=release  \
      -Dgraphite=enabled   \
      -Dbenchmark=disabled &&
ninja
sudo ninja install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://downloads.sourceforge.net/freetype/freetype-2.11.0.tar.xz
##wget --no-check-certificate https://downloads.sourceforge.net/freetype/freetype-2.11.0.tar.xz
begin freetype-2.11.0 tar.xz
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2
wget --no-check-certificate https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2
begin fontconfig-2.13.1 tar.bz2
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.13.1 &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://github.com/fribidi/fribidi/releases/download/v1.0.9/fribidi-1.0.9.tar.xz
wget --no-check-certificate https://github.com/fribidi/fribidi/releases/download/v1.0.9/fribidi-1.0.9.tar.xz
begin fribidi-1.0.9 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release .. &&
ninja
sudo ninja install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://www.cairographics.org/snapshots/cairo-1.17.4.tar.xz
#wget --no-check-certificate  https://www.cairographics.org/snapshots/cairo-1.17.4.tar.xz
begin cairo-1.17.4 tar.xz
./configure --prefix=/usr    \
            --disable-static \
            --enable-tee &&
make
sudo make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish
# There is a circular dependency between cairo and harfbuzz. If cairo is built before harfbuzz, it is necessary to rebuild cairo after harfbuzz in order to build pango.


# https://download.gnome.org/sources/pango/1.48/pango-1.48.10.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/pango/1.48/pango-1.48.10.tar.xz
begin pango-1.48.10 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release --wrap-mode=nofallback .. &&
ninja
sudo ninja install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.33.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.33.tar.xz
begin gtk+-2.24.33 tar.xz
sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
    -i docs/{faq,tutorial}/Makefile.in      &&
./configure --prefix=/usr --sysconfdir=/etc &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish

cat > ~/.gtkrc-2.0 << "EOF"
include "/usr/share/themes/Glider/gtk-2.0/gtkrc"
gtk-icon-theme-name = "hicolor"
EOF


# https://downloads.sourceforge.net/pcmanfm/libfm-1.3.2.tar.xz
wget --no-check-certificate https://downloads.sourceforge.net/pcmanfm/libfm-1.3.2.tar.xz
begin libfm-1.3.2 tar.xz
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish



# https://downloads.sourceforge.net/pcmanfm/pcmanfm-1.3.2.tar.xz
wget --no-check-certificate https://downloads.sourceforge.net/pcmanfm/pcmanfm-1.3.2.tar.xz
begin pcmanfm-1.3.2 tar.xz
./configure --prefix=/usr     \
            --sysconfdir=/etc &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/libwnck/2.30/libwnck-2.30.7.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/libwnck/2.30/libwnck-2.30.7.tar.xz
begin libwnck-2.30.7 tar.xz
./configure --prefix=/usr \
            --disable-static \
            --program-suffix=-1 &&
make GETTEXT_PACKAGE=libwnck-1
sudo make GETTEXT_PACKAGE=libwnck-1 install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish

#----------------------------------------------------------------------------------------------


# https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
begin gdk-pixbuf-2.42.6 tar.xz
mkdir build &&
cd build &&
meson --prefix=/usr --buildtype=release --wrap-mode=nofallback .. &&
ninja
sudo ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/gdk-pixbuf-xlib/2.40/gdk-pixbuf-xlib-2.40.2.tar.xz
wget --no-check-certificate  https://download.gnome.org/sources/gdk-pixbuf-xlib/2.40/gdk-pixbuf-xlib-2.40.2.tar.xz
begin gdk-pixbuf-xlib-2.40.2 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr .. &&
ninja
sudo ninja install
finish



# https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz
wget --no-check-certificate  https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz
wget --no-check-certificate  https://www.linuxfromscratch.org/patches/blfs/svn/Python-2.7.18-security_fixes-1.patch
begin  Python-2.7.18 tar.xz
sed -i '/2to3/d' ./setup.py
patch -Np1 -i ../Python-2.7.18-security_fixes-1.patch &&
./configure --prefix=/usr                              \
            --enable-shared                            \
            --with-system-expat                        \
            --with-system-ffi                          \
            --enable-unicode=ucs4                     &&
make
sudo make altinstall                                &&
sudo ln -s python2.7        /usr/bin/python2        &&
sudo ln -s python2.7-config /usr/bin/python2-config &&
sudo chmod -v 755 /usr/lib/libpython2.7.so.1.0
finish


# https://github.com/pygobject/pycairo/releases/download/v1.18.2/pycairo-1.18.2.tar.gz
wget --no-check-certificate  https://github.com/pygobject/pycairo/releases/download/v1.18.2/pycairo-1.18.2.tar.gz
begin pycairo-1.18.2 tar.gz
python2 setup.py build
sudo python2 setup.py install --optimize=1   &&
sudo python2 setup.py install_pycairo_header &&
sudo python2 setup.py install_pkgconfig
finish


# https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.7.tar.xz
wget --no-check-certificate  https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.7.tar.xz
begin pygobject-2.28.7 tar.xz
./configure --prefix=/usr --disable-introspection &&
make
sudo make install
finish


# https://download.gnome.org/sources/libglade/2.6/libglade-2.6.4.tar.bz2
wget --no-check-certificate  https://download.gnome.org/sources/libglade/2.6/libglade-2.6.4.tar.bz2
begin libglade-2.6.4 tar.bz2
sed -i '/DG_DISABLE_DEPRECATED/d' glade/Makefile.in &&
./configure --prefix=/usr --disable-static &&
make
sudo make install
finish



# https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
wget --no-check-certificate  https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
begin pygtk-2.24.0 tar.bz2
sed -i '1394,1402 d' pango.defs
./configure --prefix=/usr &&
make
sudo make install
finish




# https://github.com/kupferlauncher/keybinder/releases/download/v0.3.1/keybinder-0.3.1.tar.gz
wget --no-check-certificate  https://github.com/kupferlauncher/keybinder/releases/download/v0.3.1/keybinder-0.3.1.tar.gz
begin keybinder-0.3.1 tar.gz
./configure --prefix=/usr --disable-lua &&
make
sudo make install
finish

# https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz
wget --no-check-certificate https://hewlettpackard.github.io/wireless-tools/wireless_tools.29.tar.gz
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/svn/wireless_tools-29-fix_iwlist_scanning-1.patch
begin wireless_tools.29 tar.gz
patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch
make
sudo make PREFIX=/usr INSTALL_MAN=/usr/share/man install
finish


# https://downloads.sourceforge.net/lxde/lxpanel-0.10.1.tar.xz
wget --no-check-certificate  https://downloads.sourceforge.net/lxde/lxpanel-0.10.1.tar.xz
begin lxpanel-0.10.1 tar.xz
./configure --prefix=/usr &&
make
sudo make install
finish

#---------------------------------------------------------------------------------------------


# https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.112.tar.gz
wget --no-check-certificate  https://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.112.tar.gz
begin dbus-glib-0.112 tar.gz
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static &&
make
sudo make install
finish


# https://downloads.sourceforge.net/lxde/lxappearance-0.6.3.tar.xz
wget --no-check-certificate  https://downloads.sourceforge.net/lxde/lxappearance-0.6.3.tar.xz
begin lxappearance-0.6.3 tar.xz
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-dbus     &&
make
sudo make install
finish

#---------------------------------------------------------------------------------------------


# https://download.gnome.org/sources/gtk-doc/1.33/gtk-doc-1.33.2.tar.xz
wget --no-check-certificate  https://download.gnome.org/sources/gtk-doc/1.33/gtk-doc-1.33.2.tar.xz
begin gtk-doc-1.33.2 tar.xz
autoreconf -fiv           &&
./configure --prefix=/usr &&
make
sudo make install
finish



# https://download.gnome.org/sources/libunique/1.1/libunique-1.1.6.tar.bz2
wget --no-check-certificate  https://download.gnome.org/sources/libunique/1.1/libunique-1.1.6.tar.bz2
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/svn/libunique-1.1.6-upstream_fixes-1.patch
begin libunique-1.1.6 tar.bz2
patch -Np1 -i ../libunique-1.1.6-upstream_fixes-1.patch &&
autoreconf -fi &&
./configure --prefix=/usr  \
            --disable-dbus \
            --disable-static &&
make
sudo make install
finish

# https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz
wget --no-check-certificate  https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/svn/autoconf-2.13-consolidated_fixes-1.patch
begin autoconf-2.13 tar.gz
patch -Np1 -i ../autoconf-2.13-consolidated_fixes-1.patch &&
mv -v autoconf.texi autoconf213.texi                      &&
rm -v autoconf.info                                       &&
./configure --prefix=/usr --program-suffix=2.13           &&
make
sudo make install                                      &&
sudo install -v -m644 autoconf213.info /usr/share/info &&
sudo install-info --info-dir=/usr/share/info autoconf213.info
finish


# https://github.com/unicode-org/icu/releases/download/release-69-1/icu4c-69_1-src.tgz
wget --no-check-certificate  https://github.com/unicode-org/icu/releases/download/release-69-1/icu4c-69_1-src.tgz
tar xf icu4c-69_1-sr.tgz
cd icu/source
./configure --prefix=/usr                    &&
make
sudo make install
cd source
rm -rf icu


# https://www.linuxfromscratch.org/blfs/view/systemd/general/libssh2.html
wget --no-check-certificate  https://www.libssh2.org/download/libssh2-1.10.0.tar.gz
begin libssh2-1.10.0 tar.gz
./configure --prefix=/usr --disable-static &&
make
sudo make install
finish

# https://static.rust-lang.org/dist/rustc-1.52.0-src.tar.gz
wget --no-check-certificate  https://static.rust-lang.org/dist/rustc-1.52.0-src.tar.gz
begin rustc-1.52.0-src tar.gz
sudo mkdir /opt/rustc-1.52.0             &&
sudo ln -svfin rustc-1.52.0 /opt/rustc

cat << EOF > config.toml
# see config.toml.example for more possible options
# See the 8.4 book for an example using shipped LLVM
# e.g. if not installing clang, or using a version before 10.0
[llvm]
# by default, rust will build for a myriad of architectures
targets = "X86"

# When using system llvm prefer shared libraries
link-shared = true

[build]
# omit docs to save time and space (default is to build them)
docs = false

# install cargo as well as rust
extended = true

[install]
prefix = "/opt/rustc-1.52.0"
docdir = "share/doc/rustc-1.52.0"

[rust]
channel = "stable"
rpath = false

# BLFS does not install the FileCheck executable from llvm,
# so disable codegen tests
codegen-tests = false

[target.x86_64-unknown-linux-gnu]
# NB the output of llvm-config (i.e. help options) may be
# dumped to the screen when config.toml is parsed.
llvm-config = "/usr/bin/llvm-config"

[target.i686-unknown-linux-gnu]
# NB the output of llvm-config (i.e. help options) may be
# dumped to the screen when config.toml is parsed.
llvm-config = "/usr/bin/llvm-config"


EOF




# need js78




#  Cleaning Up
rm -rf /tmp/*a
echo "blfs-37.sh"
cat  /sources/37rc.log

