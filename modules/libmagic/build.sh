MAGISK_MODULE_HOMEPAGE=https://www.libmagic.net/
MAGISK_MODULE_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
MAGISK_MODULE_LICENSE="GPL"
MAGISK_MODULE_VERSION=5.37
MAGISK_MODULE_SHA256=662fdcb834b1ef6d14c2558306d533a738dc7218f9ec7e7ac4a775a1826df98d
MAGISK_MODULE_SRCURL=https://github.com/file/file/archive/FILE${MAGISK_MODULE_VERSION/./_}.zip
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_configure() {
	export LDFLAGS+=" -lz -static"
	#export CFLAGS+=" -static"
	cd "$MAGISK_MODULE_SRCDIR"
	#libtoolize --automake --copy --force
	#aclocal
	#autoheader
	#automake --add-missing --force-missing --copy
	autoreconf --install
	export LIBS=" -lc -lz"
	#autoreconf --install
	CC=$CC LD=$LD $MAGISK_MODULE_SRCDIR/configure --enable-static --enable-shared --prefix=$MAGISK_PREFIX --datarootdir=$MAGISK_PREFIX/usr/share --host=aarch64-linux-android --target=aarch64-linux-android
}

mmagisk_step_make() {
	export LDFLAGS+=" -lz -static"
	cd "$MAGISK_MODULE_SRCDIR"
	make -j$(nproc) CC=$CC
}
