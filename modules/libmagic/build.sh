MAGISK_MODULE_HOMEPAGE=https://www.libmagic.net/
MAGISK_MODULE_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
MAGISK_MODULE_LICENSE="GPL"
MAGISK_MODULE_VERSION=5.35
MAGISK_MODULE_SHA256=366a9174427a27dfd9f8b0420dc12654e32bb8a40cacbd2a87b5699cc650bbb8
MAGISK_MODULE_SRCURL=https://github.com/file/file/archive/FILE5_35.zip
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_configure() {
	export LDFLAGS+=" --static"
	cd "$MAGISK_MODULE_SRCDIR"
	autoreconf --install
	"$MAGISK_MODULE_SRCDIR/configure" --enable-static --disable-shared --prefix=$MAGISK_PREFIX --host=aarch64-linux-android CC=$CC LD=$LD
}

magisk_step_make() {
	export LDFLAGS+=" --static"
	cd "$MAGISK_MODULE_SRCDIR"
	make -j$(nproc) CC=$CC
}
