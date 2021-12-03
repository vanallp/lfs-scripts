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


# MESA
# Xorg Applications

# https://github.com/ivmai/libatomic_ops/releases/download/v7.6.12/libatomic_ops-7.6.12.tar.gz
wget https://github.com/ivmai/libatomic_ops/releases/download/v7.6.12/libatomic_ops-7.6.12.tar.gz
begin libatomic_ops-7.6.12 tar.gz
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static \
            --docdir=/usr/share/doc/libatomic_ops-7.6.12 &&
make
sudo make install
finish

# https://dri.freedesktop.org/libdrm/libdrm-2.4.109.tar.xz
wget https://dri.freedesktop.org/libdrm/libdrm-2.4.109.tar.xz
begin libdrm-2.4.109 tar.xz
mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX \
      --buildtype=release   \
      -Dudev=true           \
      -Dvalgrind=false      &&
ninja
sudo ninja install
finish

# https://files.pythonhosted.org/packages/source/M/Mako/Mako-1.1.6.tar.gz
wget https://files.pythonhosted.org/packages/source/M/Mako/Mako-1.1.6.tar.gz
begin Mako-1.1.6 tar.gz
sudo python3 setup.py install --optimize=1
sudo rm -rf /sources/Mako-1.1.6/*
finish

# https://wayland.freedesktop.org/releases/wayland-1.19.0.tar.xz
wget https://wayland.freedesktop.org/releases/wayland-1.19.0.tar.xz
begin wayland-1.19.0 tar.xz
mkdir build &&
cd    build &&

meson --prefix=/usr       \
      --buildtype=release \
      -Ddocumentation=false &&
ninja
sudo ninja install
finish

# https://wayland.freedesktop.org/releases/wayland-protocols-1.24.tar.xz
wget https://wayland.freedesktop.org/releases/wayland-protocols-1.24.tar.xz
begin wayland-protocols-1.24 tar.xz
mkdir build &&
cd    build &&

meson --prefix=/usr --buildtype=release &&
ninja
sudo ninja install
finish





# https://mesa.freedesktop.org/archive/mesa-21.2.5.tar.xz
wget https://mesa.freedesktop.org/archive/mesa-21.2.5.tar.xz
wget https://www.linuxfromscratch.org/patches/blfs/svn/mesa-21.2.5-add_xdemos-1.patch
begin mesa-21.2.5 tar.xz
patch -Np1 -i ../mesa-21.2.5-add_xdemos-1.patch
sed '1s/python/&3/' -i bin/symbols-check.py
GALLIUM_DRV="crocus,i915,iris,nouveau,r600,radeonsi,svga,swrast,virgl"
DRI_DRIVERS="i965,nouveau"
mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX          \
      --buildtype=release            \
      -Ddri-drivers=$DRI_DRIVERS     \
      -Dgallium-drivers=$GALLIUM_DRV \
      -Dgallium-nine=false           \
      -Dglx=dri                      \
      -Dvalgrind=disabled            \
      -Dlibunwind=disabled           \
      ..                             &&

unset GALLIUM_DRV DRI_DRIVERS &&

ninja
sudo ninja install
sudo install -v -dm755 /usr/share/doc/mesa-21.2.5 &&
sudo cp -rfv ../docs/* /usr/share/doc/mesa-21.2.5
finish

# https://www.x.org/pub/individual/data/xbitmaps-1.1.2.tar.bz2
wget https://www.x.org/pub/individual/data/xbitmaps-1.1.2.tar.bz2
begin xbitmaps-1.1.2 tar.bz2
./configure $XORG_CONFIG
sudo make install
finish

# X Apps

cat > app-7.md5 << EOF
3b9b79fa0f9928161f4bad94273de7ae  iceauth-1.0.8.tar.bz2
c4a3664e08e5a47c120ff9263ee2f20c  luit-1.1.1.tar.bz2
215940de158b1a3d8b3f8b442c606e2f  mkfontscale-1.2.1.tar.bz2
92be564d4be7d8aa7b5024057b715210  sessreg-1.1.2.tar.bz2
93e736c98fb75856ee8227a0c49a128d  setxkbmap-1.3.2.tar.bz2
3a93d9f0859de5d8b65a68a125d48f6a  smproxy-1.0.6.tar.bz2
e96b56756990c56c24d2d02c2964456b  x11perf-1.6.1.tar.bz2
325c2321d159d5b93490700960005037  xauth-1.1.1.tar.bz2
5b6405973db69c0443be2fba8e1a8ab7  xbacklight-1.2.3.tar.bz2
9956d751ea3ae4538c3ebd07f70736a0  xcmsdb-1.0.5.tar.bz2
25cc7ca1ce5dcbb61c2b471c55e686b5  xcursorgen-1.0.7.tar.bz2
8809037bd48599af55dad81c508b6b39  xdpyinfo-1.3.2.tar.bz2
480e63cd365f03eb2515a6527d5f4ca6  xdriinfo-1.0.6.tar.bz2
e1d7dc1afd3ddb8fab16d6a76f21a258  xev-1.2.4.tar.bz2
90b4305157c2b966d5180e2ee61262be  xgamma-1.0.6.tar.bz2
a48c72954ae6665e0616f6653636da8c  xhost-1.0.8.tar.bz2
ac6b7432726008b2f50eba82b0e2dbe4  xinput-1.6.3.tar.bz2
c45e9f7971a58b8f0faf10f6d8f298c0  xkbcomp-1.4.5.tar.bz2
c747faf1f78f5a5962419f8bdd066501  xkbevd-1.1.4.tar.bz2
502b14843f610af977dffc6cbf2102d5  xkbutils-1.0.4.tar.bz2
938177e4472c346cf031c1aefd8934fc  xkill-1.0.5.tar.bz2
61671fee12535347db24ec3a715032a7  xlsatoms-1.1.3.tar.bz2
4fa92377e0ddc137cd226a7a87b6b29a  xlsclients-1.1.4.tar.bz2
e50ffae17eeb3943079620cb78f5ce0b  xmessage-1.0.5.tar.bz2
51f1d30a525e9903280ffeea2744b1f6  xmodmap-1.0.10.tar.bz2
eaac255076ea351fd08d76025788d9f9  xpr-1.0.5.tar.bz2
2358e29133d183ff67d4ef8afd70b9d2  xprop-1.2.5.tar.bz2
fe40f7a4fd39dd3a02248d3e0b1972e4  xrandr-1.5.1.tar.xz
85f04a810e2fb6b41ab872b421dce1b1  xrdb-1.2.1.tar.bz2
c56fa4adbeed1ee5173f464a4c4a61a6  xrefresh-1.0.6.tar.bz2
70ea7bc7bacf1a124b1692605883f620  xset-1.2.4.tar.bz2
5fe769c8777a6e873ed1305e4ce2c353  xsetroot-1.1.2.tar.bz2
b13afec137b9b331814a9824ab03ec80  xvinfo-1.1.4.tar.bz2
f783a209f2e3fa13253cedb65eaf9cdb  xwd-1.0.8.tar.bz2
26d46f7ef0588d3392da3ad5802be420  xwininfo-1.1.5.tar.bz2
79972093bb0766fcd0223b2bd6d11932  xwud-1.0.5.tar.bz2
EOF

mkdir app &&
cd app &&
grep -v '^#' ../app-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/app/ &&
md5sum -c ../app-7.md5

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root

for package in $(grep -v '^#' ../app-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  tar -xf $package
  pushd $packagedir
     case $packagedir in
       luit-[0-9]* )
         sed -i -e "/D_XOPEN/s/5/6/" configure
       ;;
     esac

     ./configure $XORG_CONFIG
     make
     as_root make install
  popd
  rm -rf $packagedir
done

as_root rm -f $XORG_PREFIX/bin/xkeystone


# https://www.x.org/pub/individual/data/xcursor-themes-1.0.6.tar.bz2
wget https://www.x.org/pub/individual/data/xcursor-themes-1.0.6.tar.bz2
begin xcursor-themes-1.0.6 tar.bz2
./configure $XORG_CONFIG &&
make
sudo make install
finish

cat > font-7.md5 << EOF
3d6adb76fdd072db8c8fae41b40855e8  font-util-1.3.2.tar.bz2
bbae4f247b88ccde0e85ed6a403da22a  encodings-1.0.5.tar.bz2
0497de0176a0dfa5fac2b0552a4cf380  font-alias-1.0.4.tar.bz2
fcf24554c348df3c689b91596d7f9971  font-adobe-utopia-type1-1.0.4.tar.bz2
e8ca58ea0d3726b94fe9f2c17344be60  font-bh-ttf-1.0.3.tar.bz2
53ed9a42388b7ebb689bdfc374f96a22  font-bh-type1-1.0.3.tar.bz2
bfb2593d2102585f45daa960f43cb3c4  font-ibm-type1-1.0.3.tar.bz2
4ee18ab6c1edf636b8e75b73e6037371  font-misc-ethiopic-1.0.4.tar.bz2
3eeb3fb44690b477d510bbd8f86cf5aa  font-xfree86-type1-1.0.4.tar.bz2
EOF

mkdir font &&
cd font &&
grep -v '^#' ../font-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/font/ &&
md5sum -c ../font-7.md5

for package in $(grep -v '^#' ../font-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.bz2}
  tar -xf $package
  pushd $packagedir
    ./configure $XORG_CONFIG
    make
    as_root make install
  popd
  as_root rm -rf $packagedir
done

sudo install -v -d -m755 /usr/share/fonts                               &&
sudo ln -svfn $XORG_PREFIX/share/fonts/X11/OTF /usr/share/fonts/X11-OTF &&
sudo ln -svfn $XORG_PREFIX/share/fonts/X11/TTF /usr/share/fonts/X11-TTF
cd /sources

# https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.34.tar.bz2
wget https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.34.tar.bz2
begin xkeyboard-config-2.34 tar.bz2
./configure $XORG_CONFIG --with-xkb-rules-symlink=xorg &&
make
sudo make install
finish

# https://github.com/anholt/libepoxy/releases/download/1.5.9/libepoxy-1.5.9.tar.xz
wget https://github.com/anholt/libepoxy/releases/download/1.5.9/libepoxy-1.5.9.tar.xz
begin libepoxy-1.5.9 tar.xz
mkdir build &&
cd    build &&

meson --prefix=/usr --buildtype=release .. &&
ninja
sudo ninja install
finish

# https://www.x.org/pub/individual/xserver/xorg-server-1.20.13.tar.xz
wget https://www.x.org/pub/individual/xserver/xorg-server-21.1.1.tar.xz
begin xorg-server-21.1.1 tar.xz
mkdir build &&
	cd build    &&

meson --prefix=$XORG_PREFIX \
      -Dsuid_wrapper=true   \
      -Dxkb_output_dir=/var/lib/xkb &&
ninja
sudo ninja install &&
sudo mkdir -pv /etc/X11/xorg.conf.d
#./configure $XORG_CONFIG            \
#            --enable-glamor         \
#            --enable-suid-wrapper   \
#            --with-xkb-output=/var/lib/xkb &&
#make
#sudo make install &&
#sudo mkdir -pv /etc/X11/xorg.conf.d
finish

# https://www.freedesktop.org/software/libevdev/libevdev-1.12.0.tar.xz
wget https://www.freedesktop.org/software/libevdev/libevdev-1.12.0.tar.xz
begin libevdev-1.12.0 tar.xz
./configure $XORG_CONFIG  &&
make
sudo make install
finish

# https://bitmath.org/code/mtdev/mtdev-1.1.6.tar.bz2
wget https://bitmath.org/code/mtdev/mtdev-1.1.6.tar.bz2
begin mtdev-1.1.6 tar.bz2
./configure --prefix=/usr --disable-static  &&
make
sudo make install
finish

# https://www.x.org/pub/individual/driver/xf86-input-evdev-2.10.6.tar.bz2
wget https://www.x.org/pub/individual/driver/xf86-input-evdev-2.10.6.tar.bz2
begin xf86-input-evdev-2.10.6 tar.bz2
./configure $XORG_CONFIG  &&
make
sudo make install
finish

# https://www.freedesktop.org/software/libinput/libinput-1.19.2.tar.xz
wget https://www.freedesktop.org/software/libinput/libinput-1.19.2.tar.xz
begin libinput-1.19.2 tar.xz
mkdir build &&
cd    build &&

meson --prefix=$XORG_PREFIX \
      --buildtype=release   \
      -Ddebug-gui=false     \
      -Dtests=false         \
      -Ddocumentation=false \
      -Dlibwacom=false      \
      ..                    &&
ninja
sudo ninja install
finish

# https://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20210222.tar.xz
wget https://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20210222.tar.xz
begin xf86-video-intel-20210222 tar.xz
./autogen.sh $XORG_CONFIG     \
            --enable-kms-only \
            --enable-uxa      \
            --mandir=/usr/share/man &&
make
sudo make install &&
sudo mv -v /usr/share/man/man4/intel-virtual-output.4 \
      /usr/share/man/man1/intel-virtual-output.1 &&
sudo sed -i '/\.TH/s/4/1/' /usr/share/man/man1/intel-virtual-output.1
finish

# https://www.x.org/pub/individual/driver/xf86-video-fbdev-0.5.0.tar.bz2
wget https://www.x.org/pub/individual/driver/xf86-video-fbdev-0.5.0.tar.bz2
begin xf86-video-fbdev-0.5.0 tar.bz2
./configure $XORG_CONFIG  &&
make
sudo make install
finish

# https://github.com/intel/libva/releases/download/2.13.0/libva-2.13.0.tar.bz2
wget https://github.com/intel/libva/releases/download/2.13.0/libva-2.13.0.tar.bz2
begin libva-2.13.0 tar.bz2
./configure $XORG_CONFIG  &&
make
sudo make install
finish

# https://github.com/intel/intel-vaapi-driver/releases/download/2.4.1/intel-vaapi-driver-2.4.1.tar.bz2
wget https://github.com/intel/intel-vaapi-driver/releases/download/2.4.1/intel-vaapi-driver-2.4.1.tar.bz2
begin intel-vaapi-driver-2.4.1 tar.bz2
./configure $XORG_CONFIG  &&
make
sudo make install
finish

cat > legacy.dat << EOF
2a455d3c02390597feb9cefb3fe97a45 app/ bdftopcf-1.1.tar.bz2
1347c3031b74c9e91dc4dfa53b12f143 font/ font-adobe-100dpi-1.0.3.tar.bz2
6c9f26c92393c0756f3e8d614713495b font/ font-adobe-75dpi-1.0.3.tar.bz2
cb7b57d7800fd9e28ec35d85761ed278 font/ font-jis-misc-1.0.3.tar.bz2
0571bf77f8fab465a5454569d9989506 font/ font-daewoo-misc-1.0.3.tar.bz2
a2401caccbdcf5698e001784dbd43f1a font/ font-isas-misc-1.0.3.tar.bz2
c88eb44b3b903d79fb44b860a213e623 font/ font-misc-misc-1.1.2.tar.bz2
EOF

mkdir legacy &&
cd    legacy &&
grep -v '^#' ../legacy.dat | awk '{print $2$3}' | wget -i- -c \
     -B https://www.x.org/pub/individual/ &&
grep -v '^#' ../legacy.dat | awk '{print $1 " " $3}' > ../legacy.md5 &&
md5sum -c ../legacy.md5

for package in $(grep -v '^#' ../legacy.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.bz2}
  tar -xf $package
  pushd $packagedir
    ./configure $XORG_CONFIG
    make
    as_root make install
  popd
  rm -rf $packagedir
  as_root /sbin/ldconfig
done

# https://www.x.org/pub/individual/app/twm-1.0.11.tar.xz
wget https://www.x.org/pub/individual/app/twm-1.0.11.tar.xz
begin twm-1.0.11 tar.xz
sed -i -e '/^rcdir =/s,^\(rcdir = \).*,\1/etc/X11/app-defaults,' src/Makefile.in &&
./configure $XORG_CONFIG &&
make
sudo make install
finish

# https://www.x.org/archive/individual/app/xeyes-1.2.0.tar.gz
wget https://www.x.org/archive/individual/app/xeyes-1.2.0.tar.gz
begin xeyes-1.2.0 tar.gz
./configure $XORG_CONFIG &&
make
sudo make install
finish

# https://www.x.org/pub/individual/app/xclock-1.0.9.tar.bz2
wget https://www.x.org/pub/individual/app/xclock-1.0.9.tar.bz2
begin xclock-1.0.9 tar.bz2
./configure $XORG_CONFIG &&
make
sudo make install
finish


#  Cleaning Up
rm -rf /tmp/*a
echo "blfs-24.sh"
#cat  /sources/24.log

