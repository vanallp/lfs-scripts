#!/bin/bash -e
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
#wget --no-check-certificate https://github.com/htop-dev/htop/archive/refs/tags/3.0.5.tar.gz
#cd /sources
#mv 3.0.5.tar.gz htop-3.0.5.tar.gz
#begin htop-3.0.5 tar.gz
#make install ;rc=$?;echo $package_name $rc >> /sources/24rc.log
#finish
#cd /sources/blfs-systemd-units
#make install-rsyncd

# https://downloads.sourceforge.net/lxde/lxmenu-data-0.1.5.tar.xz
wget --no-check-certificate https://downloads.sourceforge.net/lxde/lxmenu-data-0.1.5.tar.xz
begin lxmenu-data-0.1.5 tar.xz
./configure --prefix=/usr --sysconfdir=/etc &&
make
make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz
wget http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz
begin libxml2-2.9.12 tar.gz
./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3 &&
make
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# http://xmlsoft.org/sources/libxslt-1.1.34.tar.gz
wget http://xmlsoft.org/sources/libxslt-1.1.34.tar.gz
begin libxslt-1.1.34 tar.gz
sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml} &&
sed -i -r '/max(Parser)?Depth/d' ./tests/fuzz/fuzz.c &&
./configure --prefix=/usr --disable-static --without-python  &&
make
make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://dist.libuv.org/dist/v1.42.0/libuv-v1.42.0.tar.gz
wget --no-check-certificate https://dist.libuv.org/dist/v1.42.0/libuv-v1.42.0.tar.gz
begin libuv-v1.42.0 tar.gz
sh autogen.sh                              &&
./configure --prefix=/usr --disable-static &&
make 
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz
wget --no-check-certificate https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz
begin lzo-2.10 tar.gz
./configure --prefix=/usr                    \
            --enable-shared                  \
            --disable-static                 \
            --docdir=/usr/share/doc/lzo-2.10 &&
make
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://ftp.gnu.org/gnu/nettle/nettle-3.7.3.tar.gz
wget --no-check-certificate https://ftp.gnu.org/gnu/nettle/nettle-3.7.3.tar.gz
begin nettle-3.7.3 tar.gz
./configure --prefix=/usr --disable-static &&
make
make install && rc=$?;echo $package_name $rc >> /sources/37rc.log
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.7.3 &&
install -v -m644 nettle.html /usr/share/doc/nettle-3.7.3
finish


# https://github.com/libarchive/libarchive/releases/download/v3.5.2/libarchive-3.5.2.tar.xz
wget --no-check-certificate  https://github.com/libarchive/libarchive/releases/download/v3.5.2/libarchive-3.5.2.tar.xz
begin libarchive-3.5.2 tar.xz
./configure --prefix=/usr --disable-static &&
make
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://curl.se/download/curl-7.78.0.tar.xz
wget --no-check-certificate  https://curl.se/download/curl-7.78.0.tar.xz
begin curl-7.78.0 tar.xz
grep -rl '#!.*python$' | xargs sed -i '1s/python/&3/'
./configure --prefix=/usr                           \
            --disable-static                        \
            --with-openssl                          \
            --enable-threaded-resolver              \
            --with-ca-path=/etc/ssl/certs &&
make
make install && rc=$?;echo $package_name $rc >> /sources/37rc.log
rm -rf docs/examples/.deps &&
find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&
install -v -d -m755 /usr/share/doc/curl-7.78.0 &&
cp -v -R docs/*     /usr/share/doc/curl-7.78.0
finish



# https://cmake.org/files/v3.21/cmake-3.21.2.tar.gz
wget --no-check-certificate https://cmake.org/files/v3.21/cmake-3.21.2.tar.gz
begin cmake-3.21.2 tar.gz
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --docdir=/share/doc/cmake-3.21.2 &&
make
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.xz
wget --no-check-certificate https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.xz
begin nasm-2.15.05 tar.xz
./configure --prefix=/usr &&
make
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
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
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://downloads.sourceforge.net/libpng/libpng-1.6.37.tar.xz
wget --no-check-certificate https://downloads.sourceforge.net/libpng/libpng-1.6.37.tar.xz
wget --no-check-certificate https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-1.6.37-apng.patch.gz
begin libpng-1.6.37 tar.xz
gzip -cd ../libpng-1.6.37-apng.patch.gz | patch -p1
./configure --prefix=/usr --disable-static &&
make
make install && ;rc=$?;echo $package_name $rc >> /sources/37rc.log
mkdir -v /usr/share/doc/libpng-1.6.37 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.37
finish

# http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz
wget http://xmlsoft.org/sources/libxml2-2.9.12.tar.gz
begin libxml2-2.9.12 tar.gz
./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3 &&
make
make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
wget --no-check-certificate https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/11.0/sgml-common-0.6.3-manpage-1.patch
begin sgml-common-0.6.3 tgz
patch -Np1 -i ../sgml-common-0.6.3-manpage-1.patch &&
autoreconf -f -i
./configure --prefix=/usr --sysconfdir=/etc &&
make
make docdir=/usr/share/doc install && ;rc=$?;echo $package_name $rc >> /sources/37rc.log
install-catalog --add /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&
install-catalog --add /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat
finish


# https://downloads.sourceforge.net/infozip/unzip60.tar.gz
wget --no-check-certificate https://downloads.sourceforge.net/infozip/unzip60.tar.gz
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/11.0/unzip-6.0-consolidated_fixes-1.patch
begin unzip60 tar.gz
patch -Np1 -i ../unzip-6.0-consolidated_fixes-1.patch
make -f unix/Makefile generic
make prefix=/usr MANDIR=/usr/share/man/man1 \
 -f unix/Makefile install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish
  

# https://www.docbook.org/xml/4.5/docbook-xml-4.5.zip
wget --no-check-certificate https://www.docbook.org/xml/4.5/docbook-xml-4.5.zip
mkdir /sources/docbook-xml-4.5
cd    /sources/docbook-xml-4.5
unzip ../docbook-xml-4.5.zip
install -v -d -m755 /usr/share/xml/docbook/xml-dtd-4.5 &&
install -v -d -m755 /etc/xml &&
chown -R root:root . &&
cp -v -af docbook.cat *.dtd ent/ *.mod \
    /usr/share/xml/docbook/xml-dtd-4.5
if [ ! -e /etc/xml/docbook ]; then
    xmlcatalog --noout --create /etc/xml/docbook
fi &&
xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V4.5//EN" \
    "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML CALS Table Model V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/calstblx.dtd" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/soextblx.dtd" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Information Pool V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbpoolx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbhierx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/htmltblx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Notations V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbnotnx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Character Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbcentx.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbgenent.mod" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook &&
xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
if [ ! -e /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
fi &&
xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//ENTITIES DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//DTD DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog

for DTDVERSION in 4.1.2 4.2 4.3 4.4
do
  xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V$DTDVERSION//EN" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/docbookx.dtd" \
    /etc/xml/docbook
  xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
  xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
  xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
  xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
done
cd /sources
rm -rf docbook-xml-4.5


# http://files.itstool.org/itstool/itstool-2.0.6.tar.bz2
wget http://files.itstool.org/itstool/itstool-2.0.6.tar.bz2
begin itstool-2.0.6 tar.bz2
PYTHON=/usr/bin/python3 ./configure --prefix=/usr &&
make
make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-nons-1.79.2.tar.bz2
wget --no-check-certificate https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-nons-1.79.2.tar.bz2
wget --no-check-certificate https://www.linuxfromscratch.org/patches/blfs/11.0/docbook-xsl-nons-1.79.2-stack_fix-1.patch
begin docbook-xsl-nons-1.79.2 tar.bz2
patch -Np1 -i ../docbook-xsl-nons-1.79.2-stack_fix-1.patch
install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 &&
cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
         highlighting html htmlhelp images javahelp lib manpages params  \
         profiling roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 xhtml5                                          \
    /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 &&
ln -s VERSION /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2/VERSION.xsl &&
install -v -m644 -D README \
                    /usr/share/doc/docbook-xsl-nons-1.79.2/README.txt &&
install -v -m644    RELEASE-NOTES* NEWS* \
                    /usr/share/doc/docbook-xsl-nons-1.79.2
if [ ! -d /etc/xml ]; then install -v -m755 -d /etc/xml; fi &&
if [ ! -f /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
fi &&

xmlcatalog --noout --add "rewriteSystem" \
           "https://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "https://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteSystem" \
           "https://cdn.docbook.org/release/xsl-nons/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "https://cdn.docbook.org/release/xsl-nons/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
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
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish




# https://download.gnome.org/sources/glib/2.68/glib-2.68.4.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/glib/2.68/glib-2.68.4.tar.xz
begin glib-2.68.4 tar.xz
mkdir build &&
cd    build &&

meson --prefix=/usr       \
      --buildtype=release \
      -Dman=true          \
      ..                  &&
ninja
ninja install &&
mkdir -p /usr/share/doc/glib-2.68.4 &&
cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.68.4
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
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
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
make install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/atk/2.36/atk-2.36.0.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/atk/2.36/atk-2.36.0.tar.xz
begin atk-2.36.0 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release .. &&
ninja
ninja install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish 

# https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.1/shared-mime-info-2.1.tar.gz
wget --no-check-certificate https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.1/shared-mime-info-2.1.tar.gz
begin shared-mime-info-2.1 tar.gz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release -Dupdate-mimedb=true .. &&
ninja
ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
begin gdk-pixbuf-2.42.6 tar.xz
mkdir build &&
cd build &&
meson --prefix=/usr --buildtype=release --wrap-mode=nofallback .. &&
ninja
ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish

# https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
wget --no-check-certificate https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
begin which-2.21 tar.gz
./configure --prefix=/usr &&
make
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish

# https://github.com/harfbuzz/harfbuzz/releases/download/2.9.0/harfbuzz-2.9.0.tar.xz
wget --no-check-certificate https://github.com/harfbuzz/harfbuzz/releases/download/2.9.0/harfbuzz-2.9.0.tar.xz
begin harfbuzz-2.9.0 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr        \
      --buildtype=release  \
      -Dgraphite=enabled   \
      -Dbenchmark=disabled &&
ninja
ninja install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://downloads.sourceforge.net/freetype/freetype-2.11.0.tar.xz
##wget --no-check-certificate https://downloads.sourceforge.net/freetype/freetype-2.11.0.tar.xz
begin freetype-2.11.0 tar.xz
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
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
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://github.com/fribidi/fribidi/releases/download/v1.0.9/fribidi-1.0.9.tar.xz
wget --no-check-certificate https://github.com/fribidi/fribidi/releases/download/v1.0.9/fribidi-1.0.9.tar.xz
begin fribidi-1.0.9 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release .. &&
ninja
ninja install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/pango/1.48/pango-1.48.9.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/pango/1.48/pango-1.48.9.tar.xz
begin pango-1.48.9 tar.xz
mkdir build &&
cd    build &&
meson --prefix=/usr --buildtype=release --wrap-mode=nofallback .. &&
ninja
ninja install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.33.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.33.tar.xz
begin gtk+-2.24.33 tar.xz
sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
    -i docs/{faq,tutorial}/Makefile.in      &&
./configure --prefix=/usr --sysconfdir=/etc &&
make
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
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
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish



# https://downloads.sourceforge.net/pcmanfm/pcmanfm-1.3.2.tar.xz
wget --no-check-certificate https://downloads.sourceforge.net/pcmanfm/pcmanfm-1.3.2.tar.xz
begin pcmanfm-1.3.2 tar.xz
./configure --prefix=/usr     \
            --sysconfdir=/etc &&
make
make install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish


# https://download.gnome.org/sources/libwnck/2.30/libwnck-2.30.7.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/libwnck/2.30/libwnck-2.30.7.tar.xz
begin libwnck-2.30.7 tar.xz
./configure --prefix=/usr \
            --disable-static \
            --program-suffix=-1 &&
make GETTEXT_PACKAGE=libwnck-1
make GETTEXT_PACKAGE=libwnck-1 install;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish



# https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
wget --no-check-certificate https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-2.42.6.tar.xz
begin gdk-pixbuf-2.42.6 tar.xz
mkdir build &&
cd build &&
meson --prefix=/usr --buildtype=release --wrap-mode=nofallback .. &&
ninja
ninja install ;rc=$?;echo $package_name $rc >> /sources/37rc.log
finish





#  Cleaning Up
rm -rf /tmp/*a
echo "blfs-37.sh"
cat  /sources/37rc.log

