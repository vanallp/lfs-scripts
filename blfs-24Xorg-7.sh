#!/bin/bash  -e
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

# https://www.x.org/pub/individual/util/util-macros-1.19.3.tar.bz2
wget   https://www.x.org/pub/individual/util/util-macros-1.19.3.tar.bz2
begin util-macros-1.19.3 tar.bz2
./configure $XORG_CONFIG
make install 
finish

# https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2021.5.tar.bz2
wget   https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2021.5.tar.bz2
begin xorgproto-2021.5 tar.bz2
mkdir build &&
cd    build &&
meson --prefix=$XORG_PREFIX -Dlegacy=true .. &&
ninja
sudo ninja install &&
sudo install -vdm 755 $XORG_PREFIX/share/doc/xorgproto-2021.5 &&
sudo install -vm 644 ../[^m]*.txt ../PM_spec $XORG_PREFIX/share/doc/xorgproto-2021.5
finish

# https://www.x.org/pub/individual/lib/libXau-1.0.9.tar.bz2
wget   https://www.x.org/pub/individual/lib/libXau-1.0.9.tar.bz2
begin libXau-1.0.9 tar.bz2
./configure $XORG_CONFIG &&
make
sudo make install
finish

# https://www.x.org/pub/individual/lib/libXdmcp-1.1.3.tar.bz2
wget   https://www.x.org/pub/individual/lib/libXdmcp-1.1.3.tar.bz2
begin libXdmcp-1.1.3 tar.bz2
./configure $XORG_CONFIG --docdir=/usr/share/doc/libXdmcp-1.1.3 &&
make
sudo make install
finish

# https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.14.1.tar.xz
wget   https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.14.1.tar.xz
begin xcb-proto-1.14.1 tar.xz
PYTHON=python3 ./configure $XORG_CONFIG
sudo make install
finish

# https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.14.tar.xz
wget  https://xorg.freedesktop.org/archive/individual/lib/libxcb-1.14.tar.xz
begin libxcb-1.14 tar.xz
CFLAGS="${CFLAGS:--O2 -g} -Wno-error=format-extra-args" \
PYTHON=python3                \
./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.14 &&
make
sudo make install
finish

cd /sources
cat > lib-7.md5 << EOF
ce2fb8100c6647ee81451ebe388b17ad  xtrans-1.4.0.tar.bz2
a9a24be62503d5e34df6b28204956a7b  libX11-1.7.2.tar.bz2
f5b48bb76ba327cd2a8dc7a383532a95  libXext-1.3.4.tar.bz2
4e1196275aa743d6ebd3d3d5ec1dff9c  libFS-1.0.8.tar.bz2
76d77499ee7120a56566891ca2c0dbcf  libICE-1.0.10.tar.bz2
87c7fad1c1813517979184c8ccd76628  libSM-1.2.3.tar.bz2
eeea9d5af3e6c143d0ea1721d27a5e49  libXScrnSaver-1.2.3.tar.bz2
b122ff9a7ec70c94dbbfd814899fffa5  libXt-1.2.1.tar.bz2
ac774cff8b493f566088a255dbf91201  libXmu-1.1.3.tar.bz2
6f0ecf8d103d528cfc803aa475137afa  libXpm-3.5.13.tar.bz2
c1ce21c296bbf3da3e30cf651649563e  libXaw-1.0.14.tar.bz2
86f182f487f4f54684ef6b142096bb0f  libXfixes-6.0.0.tar.bz2
3fa0841ea89024719b20cd702a9b54e0  libXcomposite-0.4.5.tar.bz2
802179a76bded0b658f4e9ec5e1830a4  libXrender-0.9.10.tar.bz2
9b9be0e289130fb820aedf67705fc549  libXcursor-1.2.0.tar.bz2
e3f554267a7a04b042dc1f6352bd6d99  libXdamage-1.1.5.tar.bz2
6447db6a689fb530c218f0f8328c3abc  libfontenc-1.1.4.tar.bz2
bdf528f1d337603c7431043824408668  libXfont2-2.0.5.tar.bz2
5004d8e21cdddfe53266b7293c1dfb1b  libXft-2.3.4.tar.bz2
74055672a111a98ce2841d2ec4057b05  libXi-1.8.tar.bz2
0d5f826a197dae74da67af4a9ef35885  libXinerama-1.1.4.tar.bz2
18f3b20d522f45e4dadd34afb5bea048  libXrandr-1.5.2.tar.bz2
e142ef0ed0366ae89c771c27cfc2ccd1  libXres-1.2.1.tar.bz2
ef8c2c1d16a00bd95b9fdcef63b8a2ca  libXtst-1.2.3.tar.bz2
210b6ef30dda2256d54763136faa37b9  libXv-1.0.11.tar.bz2
3569ff7f3e26864d986d6a21147eaa58  libXvMC-1.0.12.tar.bz2
0ddeafc13b33086357cfa96fae41ee8e  libXxf86dga-1.1.5.tar.bz2
298b8fff82df17304dfdb5fe4066fe3a  libXxf86vm-1.1.4.tar.bz2
d2f1f0ec68ac3932dd7f1d9aa0a7a11c  libdmx-1.1.4.tar.bz2
b34e2cbdd6aa8f9cc3fa613fd401a6d6  libpciaccess-0.16.tar.bz2
dd7e1e946def674e78c0efbc5c7d5b3b  libxkbfile-1.1.0.tar.bz2
42dda8016943dc12aff2c03a036e0937  libxshmfence-1.3.tar.bz2
EOF

mkdir lib &&
cd lib &&
grep -v '^#' ../lib-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/lib/ &&
md5sum -c ../lib-7.md5

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root

for package in $(grep -v '^#' ../lib-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.bz2}
  tar -xf $package
  pushd $packagedir
  docdir="--docdir=$XORG_PREFIX/share/doc/$packagedir"
  case $packagedir in
    libICE* )
      ./configure $XORG_CONFIG $docdir ICE_LIBS=-lpthread
    ;;
    libXfont2-[0-9]* )
      ./configure $XORG_CONFIG $docdir --disable-devel-docs
    ;;
    libXt-[0-9]* )
      ./configure $XORG_CONFIG $docdir \
                  --with-appdefaultdir=/etc/X11/app-defaults
    ;;
    * )
      ./configure $XORG_CONFIG $docdir
    ;;
  esac
  make
  as_root make install
  popd
  rm -rf $packagedir
  as_root /sbin/ldconfig
done

# https://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2
wget https://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2
begin xcb-util-0.4.0 tar.bz2
./configure $XORG_CONFIG &&
make
sudo make install
finish

# https://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.bz2
wget https://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.bz2
begin xcb-util-image-0.4.0 tar.bz2
./configure $XORG_CONFIG &&
make
sudo make install
finish

# https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2
wget https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2
begin xcb-util-keysyms-0.4.0 tar.bz2
./configure $XORG_CONFIG &&
make
sudo make install
finish

# https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2
wget https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2
begin xcb-util-renderutil-0.3.9 tar.bz2
./configure $XORG_CONFIG &&
make
sudo make install
finish

# https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.1.tar.bz2
wget https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.1.tar.bz2
begin xcb-util-wm-0.4.1 tar.bz2
./configure $XORG_CONFIG &&
make
sudo make install
finish

# https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.3.tar.bz2
wget https://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.3.tar.bz2
begin xcb-util-cursor-0.1.3 tar.bz2
./configure $XORG_CONFIG &&
make
sudo make install
finish

# MESA
# Xorg Applications




#  Cleaning Up
rm -rf /tmp/*a
echo "blfs-24.sh"
#cat  /sources/24.log

