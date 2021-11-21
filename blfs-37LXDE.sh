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



# https://github.com/libarchive/libarchive/releases/download/v3.5.2/libarchive-3.5.2.tar.xz
wget --no-check-certificate  https://github.com/libarchive/libarchive/releases/download/v3.5.2/libarchive-3.5.2.tar.xz
begin libarchive-3.5.2 tar.xz
./configure --prefix=/usr --disable-static &&
make
sudo make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://curl.se/download/curl-7.80.0.tar.xz
wget --no-check-certificate  https://curl.se/download/curl-7.80.0.tar.xz
begin curl-7.80.0 tar.xz
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
sudo install -v -d -m755 /usr/share/doc/curl-7.80.0 &&
sudo cp -v -R docs/*     /usr/share/doc/curl-7.80.0
finish



# https://cmake.org/files/v3.21/cmake-3.21.4.tar.gz
wget --no-check-certificate https://cmake.org/files/v3.21/cmake-3.21.4.tar.gz
begin cmake-3.21.4 tar.gz
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --docdir=/share/doc/cmake-3.21.4 &&
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
# https://sourceware.org/ftp/valgrind/valgrind-3.18.1.tar.bz2
wget --no-check-certificate  https://www.linuxfromscratch.org/patches/blfs/svn/valgrind-3.18.1-upstream_fixes-1.patch
wget --no-check-certificate  https://sourceware.org/ftp/valgrind/valgrind-3.18.1.tar.bz2
begin valgrind-3.18.1 tar.bz2
patch -Np1 -i ../valgrind-3.18.1-upstream_fixes-1.patch
autoreconf -fiv &&
sed -i 's|/doc/valgrind||' docs/Makefile.in &&
./configure --prefix=/usr \
            --datadir=/usr/share/doc/valgrind-3.18.1 &&
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



# https://download.gnome.org/sources/glib/2.70/glib-2.70.1.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/glib/2.70/glib-2.70.1.tar.xz
begin glib-2.70.1 tar.xz
mkdir build &&
cd    build &&

meson --prefix=/usr       \
      --buildtype=release \
      -Dman=true          \
      ..                  &&
ninja
sudo ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
sudo mkdir -p /usr/share/doc/glib-2.70.1 &&
sudo cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.70.1
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
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/svn/shared-mime-info-2.1-shared-mime-info_meson_0.60_fix-1.patch
begin shared-mime-info-2.1 tar.gz
patch -p1 -i ../shared-mime-info-2.1-shared-mime-info_meson_0.60_fix-1.patch
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


# https://github.com/harfbuzz/harfbuzz/releases/download/3.1.1/harfbuzz-3.1.1.tar.xz
wget --no-check-certificate https://github.com/harfbuzz/harfbuzz/releases/download/3.1.1/harfbuzz-3.1.1.tar.xz
begin harfbuzz-3.1.1 tar.xz
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


# https://github.com/fribidi/fribidi/releases/download/v1.0.11/fribidi-1.0.11.tar.xz
wget --no-check-certificate https://github.com/fribidi/fribidi/releases/download/v1.0.11/fribidi-1.0.11.tar.xz
begin fribidi-1.0.11 tar.xz
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

# https://github.com/lopesivan/libXft-2.3.3.git


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


# https://www.linuxfromscratch.org/blfs/view/systemd/general/libssh2.html
wget --no-check-certificate  https://www.libssh2.org/download/libssh2-1.10.0.tar.gz
begin libssh2-1.10.0 tar.gz
./configure --prefix=/usr --disable-static &&
make
sudo make install
finish

# https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/llvm-13.0.0.src.tar.xz
wget  https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/llvm-13.0.0.src.tar.xz
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/clang-13.0.0.src.tar.xz
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/compiler-rt-13.0.0.src.tar.xz
begin llvm-13.0.0.src tar.xz

tar -xf ../clang-13.0.0.src.tar.xz -C tools &&
mv tools/clang-13.0.0.src tools/clang
tar -xf ../compiler-rt-13.0.0.src.tar.xz -C projects &&
mv projects/compiler-rt-13.0.0.src projects/compiler-rt
grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'
mkdir -v build &&
cd       build &&

CC=gcc CXX=g++                                  \
cmake -DCMAKE_INSTALL_PREFIX=/usr               \
      -DLLVM_ENABLE_FFI=ON                      \
      -DCMAKE_BUILD_TYPE=Release                \
      -DLLVM_BUILD_LLVM_DYLIB=ON                \
      -DLLVM_LINK_LLVM_DYLIB=ON                 \
      -DLLVM_ENABLE_RTTI=ON                     \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
      -DLLVM_BUILD_TESTS=ON                     \
      -DLLVM_BINUTILS_INCDIR=/usr/include       \
      -Wno-dev -G Ninja ..                      &&
ninja -j6
sudo ninja install
finish

# https://github.com/unicode-org/icu/releases/download/release-70-0/icu4c-70_0-src.tgz
wget --no-check-certificate  https://github.com/unicode-org/icu/releases/download/release-70-0/icu4c-70_0-src.tgz
tar xf icu4c-70_0-src.tgz
cd icu/source
./configure --prefix=/usr                    &&
make
sudo make install
cd /sources
rm -rf icu


# https://static.rust-lang.org/dist/rustc-1.56.1-src.tar.gz
wget --no-check-certificate  https://static.rust-lang.org/dist/rustc-1.56.1-src.tar.gz
begin rustc-1.56.1-src tar.gz
sudo mkdir /opt/rustc-1.56.1             &&
sudo ln -svfin rustc-1.56.1 /opt/rustc

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
prefix = "/opt/rustc-1.56.1"
docdir = "share/doc/rustc-1.56.1"

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
sed -i -e '/^curl /s/0.4.38/0.4.40/' \
       -e '/^curl-sys /s/0.4.48/0.4.50/' \
       src/tools/cargo/Cargo.toml &&
export RUSTFLAGS="$RUSTFLAGS -C link-args=-lffi" &&
python3 ./x.py build --exclude src/tools/miri

#run tests
#python3 ./x.py test --verbose --no-fail-fast | tee rustc-testlog
#grep '^test result:' rustc-testlog | awk  '{ sum += $6 } END { print sum }'

export LIBSSH2_SYS_USE_PKG_CONFIG=1 &&
DESTDIR=${PWD}/install python3 ./x.py install &&
unset LIBSSH2_SYS_USE_PKG_CONFIG

sudo chown -R root:root install &&
sudo cp -a install/* /

cat >> /tmp/ld.so.conf << EOF
# Begin rustc addition

/opt/rustc/lib

# End rustc addition
EOF
sudo mv /tmp/ld.so.conf /etc/ld.so.conf
sudo chown root:root /etc/ld.so.conf
sudo ldconfig
cat > /tmp/rustc.sh << EOF
# Begin /etc/profile.d/rustc.sh

pathprepend /opt/rustc/bin           PATH

# End /etc/profile.d/rustc.sh
EOF
sudo mv /tmp/rustc.sh /etc/profile.d/rustc.sh
sudo chown root:root /etc/profile.d/rustc.sh
#finish 
sudo rm -rf /sources/rustc-1.56.1-src
source /etc/profile.d/rustc.sh

# need js78
# https://archive.mozilla.org/pub/firefox/releases/78.15.0esr/source/firefox-78.15.0esr.source.tar.xz
wget https://archive.mozilla.org/pub/firefox/releases/78.15.0esr/source/firefox-78.15.0esr.source.tar.xz
tar xf firefox-78.15.0esr.source.tar.xz
cd firefox-78.15.0
mkdir obj &&
cd    obj &&

CC=gcc CXX=g++ \
../js/src/configure --prefix=/usr            \
                    --with-intl-api          \
                    --with-system-zlib       \
                    --with-system-icu        \
                    --disable-jemalloc       \
                    --disable-debug-symbols  \
                    --enable-readline        &&
make
sudo make install
sudo rm -v /usr/lib/libjs_static.ajs 
sudo sed -i '/@NSPR_CFLAGS@/d' /usr/bin/js78-config
cd /sources
rm -rf /sources/firefox-78.15.0


# https://www.freedesktop.org/software/polkit/releases/polkit-0.120.tar.gz
wget https://www.freedesktop.org/software/polkit/releases/polkit-0.120.tar.gz
begin polkit-0.120 tar.gz
sudo groupadd -fg 27 polkitd 
sudo useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     \
            --with-os-type=LFS   &&
make
sudo make install
cat > /tmp/polkit-1 << EOF
# Begin /etc/pam.d/polkit-1

auth     include        system-auth
account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/polkit-1
EOF
sudo mv /tmp/polkit-1 /etc/pam.d/polkit-1
sudo chown root:root /etc/pam.d/polkit-1
finish

# https://gitlab.com/graphviz/graphviz/-/archive/2.49.3/graphviz-2.49.3.tar.gz
wget https://gitlab.com/graphviz/graphviz/-/archive/2.49.3/graphviz-2.49.3.tar.gz
begin graphviz-2.49.3 tar.gz
sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac &&

./autogen.sh              &&
./configure --prefix=/usr \
            --disable-php &&
make
sudo make install
sudo ln -svr /usr/share/graphviz/doc /usr/share/doc/graphviz-2.49.3
finish

# https://download.gnome.org/sources/vala/0.54/vala-0.54.1.tar.xz
wget https://download.gnome.org/sources/vala/0.54/vala-0.54.1.tar.xz
begin vala-0.54.1 tar.xz
./configure --prefix=/usr &&
make
sudo make install
finish

# https://github.com/lfs-book/LSB-Tools/releases/download/v0.9/LSB-Tools-0.9.tar.gz
wget https://github.com/lfs-book/LSB-Tools/releases/download/v0.9/LSB-Tools-0.9.tar.gz
begin LSB-Tools-0.9 tar.gz
python3 setup.py build
sudo python3 setup.py install --optimize=1
finish


# https://downloads.sourceforge.net/lxde/lxsession-0.5.5.tar.xz
wget https://downloads.sourceforge.net/lxde/lxsession-0.5.5.tar.xz
begin lxsession-0.5.5 tar.xz
./configure --prefix=/usr --disable-man &&
make
sudo make install
finish

# https://downloads.sourceforge.net/lxde/lxde-icon-theme-0.5.1.tar.xz
wget https://downloads.sourceforge.net/lxde/lxde-icon-theme-0.5.1.tar.xz
begin lxde-icon-theme-0.5.1 tar.xz
./configure --prefix=/usr  &&
make
sudo make install
sudo gtk-update-icon-cache -qf /usr/share/icons/nuoveXT2
finish

# http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz
wget http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz
begin openbox-3.6.1 tar.gz
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir=/usr/share/doc/openbox-3.6.1 &&
make
sudo make install
finish


# https://downloads.sourceforge.net/pcmanfm/pcmanfm-1.3.2.tar.xz
wget https://downloads.sourceforge.net/pcmanfm/pcmanfm-1.3.2.tar.xz
begin pcmanfm-1.3.2 tar.xz
./configure --prefix=/usr     \
            --sysconfdir=/etc &&
make
sudo make install
finish

# https://downloads.sourceforge.net/lxde/lxde-common-0.99.2.tar.xz
wget https://downloads.sourceforge.net/lxde/lxde-common-0.99.2.tar.xz
begin lxde-common-0.99.2 tar.xz
./configure --prefix=/usr --sysconfdir=/etc &&
make
sudo make install
sudo update-mime-database /usr/share/mime &&
sudo gtk-update-icon-cache -qf /usr/share/icons/hicolor &&
sudo update-desktop-database -q

cat > ~/.xinitrc << EOF
# No need to run dbus-launch, since it is run by startlxde
startlxde
EOF

# https://invisible-mirror.net/archives/xterm/xterm-370.tgz
wget https://invisible-mirror.net/archives/xterm/xterm-370.tgz
begin xterm-370 tgz
sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap &&
printf '\tkbs=\\177,\n' >> terminfo &&

TERMINFO=/usr/share/terminfo \
./configure $XORG_CONFIG     \
    --with-app-defaults=/etc/X11/app-defaults &&

make
sudo make install    &&
sudo make install-ti &&
sudo mkdir -pv /usr/share/applications &&
sudo cp -v *.desktop /usr/share/applications/
finish

cat >> /tmp/XTerm << EOF
*VT100*locale: true
*VT100*faceName: Monospace
*VT100*faceSize: 10
*backarrowKeyIsErase: true
*ptyInitialErase: true
EOF
sudo mv /tmp/XTerm /etc/X11/app-defaults/XTerm
sudo chown root:root /etc/X11/app-defaults/XTerm

# https://www.x.org/pub/individual/app/xinit-1.4.1.tar.bz2
wget https://www.x.org/pub/individual/app/xinit-1.4.1.tar.bz2
begin xinit-1.4.1 tar.bz2
./configure $XORG_CONFIG --with-xinitdir=/etc/X11/app-defaults &&
make
sudo make install
sudo ldconfig
finish

## 
tar xf firefox-78.15.0esr.source.tar.xz

#dependencies

# https://github.com/eqrion/cbindgen/archive/v0.20.0/cbindgen-0.20.0.tar.gz
wget https://github.com/eqrion/cbindgen/archive/v0.20.0/cbindgen-0.20.0.tar.gz
begin cbindgen-0.20.0 tar.gz
cargo build --release
sudo install -Dm755 target/release/cbindgen /usr/bin/
finish

# https://download.gnome.org/sources/at-spi2-core/2.40/at-spi2-core-2.40.3.tar.xz
wget https://download.gnome.org/sources/at-spi2-core/2.40/at-spi2-core-2.40.3.tar.xz
begin at-spi2-core-2.40.3 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release .. &&
ninja
sudo ninja install
finish

# https://download.gnome.org/sources/at-spi2-atk/2.38/at-spi2-atk-2.38.0.tar.xz
wget https://download.gnome.org/sources/at-spi2-atk/2.38/at-spi2-atk-2.38.0.tar.xz
begin at-spi2-atk-2.38.0 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release .. &&
ninja
sudo ninja install
finish

# https://xkbcommon.org/download/libxkbcommon-1.3.1.tar.xz
wget https://xkbcommon.org/download/libxkbcommon-1.3.1.tar.xz
begin libxkbcommon-1.3.1 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release -Denable-docs=false .. &&
ninja
sudo ninja install
finish



# https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.30.tar.xz
wget https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.30.tar.xz
begin gtk+-3.24.30 tar.xz
./configure --prefix=/usr              \
            --sysconfdir=/etc          \
            --enable-broadway-backend  \
            --enable-x11-backend       \
            --enable-wayland-backend   &&
make
sudo make install
finish


# https://c-ares.haxx.se/download/c-ares-1.18.1.tar.gz
wget https://c-ares.haxx.se/download/c-ares-1.18.1.tar.gz
begin c-ares-1.18.1 tar.gz
mkdir build &&
cd    build &&
cmake  -DCMAKE_INSTALL_PREFIX=/usr .. &&
make
sudo make install
finish

# https://github.com/nghttp2/nghttp2/releases/download/v1.46.0/nghttp2-1.46.0.tar.xz
wget https://github.com/nghttp2/nghttp2/releases/download/v1.46.0/nghttp2-1.46.0.tar.xz
begin nghttp2-1.46.0 tar.xz
./configure --prefix=/usr     \
            --disable-static  \
            --enable-lib-only \
            --docdir=/usr/share/doc/nghttp2-1.46.0 &&
make
sudo make install
finish

# https://nodejs.org/dist/v14.18.1/node-v14.18.1.tar.xz
wget https://nodejs.org/dist/v14.18.1/node-v14.18.1.tar.xz
begin node-v14.18.1 tar.xz
sed -i 's|ares_nameser.h|arpa/nameser.h|' src/cares_wrap.h &&
./configure --prefix=/usr                  \
            --shared-cares                 \
            --shared-libuv                 \
            --shared-openssl               \
            --shared-nghttp2               \
            --shared-zlib                  \
            --with-intl=system-icu         &&
make
sudo make install &&
sudo ln -sf node /usr/share/doc/node-14.18.1
finish

# https://github.com/libsndfile/libsndfile/releases/download/1.0.31/libsndfile-1.0.31.tar.bz2
wget https://github.com/libsndfile/libsndfile/releases/download/1.0.31/libsndfile-1.0.31.tar.bz2
begin libsndfile-1.0.31 tar.bz2
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libsndfile-1.0.31 &&
make
sudo make install
finish

# https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-15.0.tar.xz
wget https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-15.0.tar.xz
begin pulseaudio-15.0 tar.xz
mkdir build &&
cd    build &&

meson --prefix=/usr       \
      --buildtype=release \
      -Ddatabase=gdbm     \
      -Ddoxygen=false     \
      -Dbluez5=disabled   &&
ninja
sudo ninja install
sudo rm -fv /etc/dbus-1/system.d/pulseaudio-system.conf
finish

# https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz
wget https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz
begin startup-notification-0.12 tar.gz
./configure --prefix=/usr --disable-static &&
make
sudo make install &&
sudo install -v -m644 -D doc/startup-notification.txt \
    /usr/share/doc/startup-notification-0.12/startup-notification.txt
finish

# https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
wget https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
begin yasm-1.3.0 tar.gz
sed -i 's#) ytasm.*#)#' Makefile.in &&
./configure --prefix=/usr &&
make
sudo make install
finish

# https://downloads.sourceforge.net/infozip/zip30.tar.gz
wget https://downloads.sourceforge.net/infozip/zip30.tar.gz
begin zip30 tar.gz
make -f unix/Makefile generic_gcc
sudo make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install
finish

# https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.9.tar.xz
wget https://download.gnome.org/sources/libnotify/0.7/libnotify-0.7.9.tar.xz
begin libnotify-0.7.9 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr       \
      --buildtype=release \
      -Dgtk_doc=false     \
      -Dman=false .. &&
ninja
sudo ninja install
finish



# http://downloads.webmproject.org/releases/webp/libwebp-1.2.1.tar.gz
wget http://downloads.webmproject.org/releases/webp/libwebp-1.2.1.tar.gz
begin libwebp-1.2.1 tar.gz
./configure --prefix=/usr           \
            --enable-libwebpmux     \
            --enable-libwebpdemux   \
            --enable-libwebpdecoder \
            --enable-libwebpextras  \
            --enable-swap-16bit-csp \
            --disable-static        &&
make
sudo make install
finish

# https://github.com/webmproject/libvpx/archive/v1.11.0/libvpx-1.11.0.tar.gz
wget https://github.com/webmproject/libvpx/archive/v1.11.0/libvpx-1.11.0.tar.gz
begin libvpx-1.11.0 tar.gz
sed -i 's/cp -p/cp/' build/make/Makefile &&
mkdir libvpx-build            &&
cd    libvpx-build            &&
../configure --prefix=/usr    \
             --enable-shared  \
             --disable-static &&
make
sudo make install
finish



#
begin firefox-78.15.0esr.source tar.xz
cat > mozconfig << EOF
# If you have a multicore machine, all cores will be used by default.

# If you have installed (or will install) wireless-tools, and you wish
# to use geolocation web services, comment out this line
ac_add_options --disable-necko-wifi

# API Keys for geolocation APIs - necko-wifi (above) is required for MLS
# Uncomment the following line if you wish to use Mozilla Location Service
#ac_add_options --with-mozilla-api-keyfile=$PWD/mozilla-key

# Uncomment the following line if you wish to use Google's geolocaton API
# (needed for use with saved maps with Google Maps)
#ac_add_options --with-google-location-service-api-keyfile=$PWD/google-key

# startup-notification is required since firefox-78

# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# or uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --with-system-libevent
ac_add_options --with-system-webp
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu

# Do not specify the gold linker which is not the default. It will take
# longer and use more disk space when debug symbols are disabled.

# libdavid (av1 decoder) requires nasm. Uncomment this if nasm
# has not been installed.
#ac_add_options --disable-av1

# You cannot distribute the binary if you do this
ac_add_options --enable-official-branding

# Stripping is now enabled by default.
# Uncomment these lines if you need to run a debugger:
#ac_add_options --disable-strip
#ac_add_options --disable-install-strip

# Disabling debug symbols makes the build much smaller and a little
# faster. Comment this if you need to run a debugger. Note: This is
# required for compilation on i686.
ac_add_options --disable-debug-symbols

# The elf-hack is reported to cause failed installs (after successful builds)
# on some machines. It is supposed to improve startup time and it shrinks
# libxul.so by a few MB - comment this if you know your machine is not affected.
ac_add_options --disable-elf-hack

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=browser
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
# enabling the tests will use a lot more space and significantly
# increase the build time, for no obvious benefit.
ac_add_options --disable-tests

# The default level of optimization again produces a working build with gcc.
ac_add_options --enable-optimize

ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

# --with-system-bz2 was removed in firefox-78
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

# The following option unsets Telemetry Reporting. With the Addons Fiasco,
# Mozilla was found to be collecting user's data, including saved passwords and
# web form data, without users consent. Mozilla was also found shipping updates
# to systems without the user's knowledge or permission.
# As a result of this, use the following command to permanently disable
# telemetry reporting in Firefox.
unset MOZ_TELEMETRY_REPORTING

mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir
EOF

sed -e 's/Disable/Enable/'            \
    -e '/^MOZ_REQUIRE_SIGNING/s/0/1/' \
    -i build/mozconfig.common

export CC=gcc CXX=g++ &&
export MOZBUILD_STATE_PATH=${PWD}/mozbuild &&
./mach configure  | tee buildlog.log                         &&
./mach build -j6

sudo ./mach install
unset CC CXX MOZBUILD_STATE_PATH


# https://archive.mozilla.org/pub/seamonkey/releases/2.53.9.1/source/seamonkey-2.53.9.1.source.tar.xz
wget https://archive.mozilla.org/pub/seamonkey/releases/2.53.9.1/source/seamonkey-2.53.9.1.source.tar.xz
begin seamonkey-2.53.9.1.source tar.xz

cat > mozconfig << EOF
# If you have a multicore machine, all cores will be used
# unless you pass -jN to ./mach build

# If you have installed DBus-Glib comment out this line:
ac_add_options --disable-dbus

# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
ac_add_options --disable-necko-wifi

# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification

# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# and uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa

# Comment out following option if you have gconf installed
ac_add_options --disable-gconf

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --with-system-icu
ac_add_options --with-system-libevent
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-webp

# The elf-hack is reported to cause failed installs (after successful builds)
# on some machines. It is supposed to improve startup time and it shrinks
# libxul.so by a few MB - comment this if you know your machine is not affected.
ac_add_options --disable-elf-hack

# Seamonkey has some additional features that are not turned on by default,
# such as an IRC client, calendar, and DOM Inspector. The DOM Inspector
# aids with designing web pages. Comment these options if you do not
# desire these features.
ac_add_options --enable-calendar
ac_add_options --enable-dominspector
ac_add_options --enable-irc

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=comm/suite

ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests

# rust-simd does not compile with recent versions of rust.
# It is disabled in recent versions of firefox
ac_add_options --disable-rust-simd

ac_add_options --enable-optimize="-O2"
ac_add_options --enable-strip
ac_add_options --enable-install-strip
ac_add_options --enable-official-branding

# The option to use system cairo was removed in 2.53.9.
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
EOF

export CC=gcc CXX=g++ &&
./mach configure      &&
./mach build -j6
sudo ./mach install                  &&
sudo chown -R 0:0 /usr/lib/seamonkey &&
sudo cp -v $(find -name seamonkey.1 | head -n1) /usr/share/man/man1



# https://archive.mozilla.org/pub/firefox/releases/91.2.0esr/source/firefox-91.3.0esr.source.tar.xz
wget https://archive.mozilla.org/pub/firefox/releases/91.2.0esr/source/firefox-91.3.0esr.source.tar.xz
wget https://www.linuxfromscratch.org/patches/blfs/svn/firefox-91.3.0esr-disable_rust_test-1.patch
begin firefox-91.3.0esr.source tar.xz
cd firefox-91.3.0
patch -Np1 -i ../firefox-91.3.0esr-disable_rust_test-1.patch
cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used by default.

# If you have installed (or will install) wireless-tools, and you wish
# to use geolocation web services, comment out this line
ac_add_options --disable-necko-wifi

# API Keys for geolocation APIs - necko-wifi (above) is required for MLS
# Uncomment the following line if you wish to use Mozilla Location Service
#ac_add_options --with-mozilla-api-keyfile=$PWD/mozilla-key

# Uncomment the following line if you wish to use Google's geolocaton API
# (needed for use with saved maps with Google Maps)
#ac_add_options --with-google-location-service-api-keyfile=$PWD/google-key

# startup-notification is required since firefox-78

# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# or uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --with-system-icu
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-webp

# Do not specify the gold linker which is not the default. It will take
# longer and use more disk space when debug symbols are disabled.

# libdavid (av1 decoder) requires nasm. Uncomment this if nasm
# has not been installed.
#ac_add_options --disable-av1

# You cannot distribute the binary if you do this
ac_add_options --enable-official-branding

# Stripping is now enabled by default.
# Uncomment these lines if you need to run a debugger:
#ac_add_options --disable-strip
#ac_add_options --disable-install-strip

# Disabling debug symbols makes the build much smaller and a little
# faster. Comment this if you need to run a debugger. Note: This is
# required for compilation on i686.
ac_add_options --disable-debug-symbols

# The elf-hack is reported to cause failed installs (after successful builds)
# on some machines. It is supposed to improve startup time and it shrinks
# libxul.so by a few MB - comment this if you know your machine is not affected.
ac_add_options --disable-elf-hack

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=browser
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
# enabling the tests will use a lot more space and significantly
# increase the build time, for no obvious benefit.
ac_add_options --disable-tests

# The default level of optimization again produces a working build with gcc.
ac_add_options --enable-optimize

ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

# The following option unsets Telemetry Reporting. With the Addons Fiasco,
# Mozilla was found to be collecting user's data, including saved passwords and
# web form data, without users consent. Mozilla was also found shipping updates
# to systems without the user's knowledge or permission.
# As a result of this, use the following command to permanently disable
# telemetry reporting in Firefox.
unset MOZ_TELEMETRY_REPORTING

mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir
EOF

export CC=gcc CXX=g++ &&
export MACH_USE_SYSTEM_PYTHON=1            &&
export MOZBUILD_STATE_PATH=${PWD}/mozbuild &&
./mach configure                           &&
./mach build -j4
sudo MACH_USE_SYSTEM_PYTHON=1 ./mach install
unset CC CXX MACH_USE_SYSTEM_PYTHON MOZBUILD_STATE_PATH






#  Cleaning Up
rm -rf /tmp/*a
echo "blfs-37.sh"
cat  /sources/37rc.log

