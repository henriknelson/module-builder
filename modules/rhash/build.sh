MAGISK_MODULE_HOMEPAGE=https://github.com/rhash/RHash
MAGISK_MODULE_DESCRIPTION="Console utility for calculation and verification of magnet links and a wide range of hash sums"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.3.9
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/rhash/RHash/archive/v$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=42b1006f998adb189b1f316bf1a60e3171da047a85c4aaded2d0d26c1476c9f6
MAGISK_MODULE_DEPENDS="openssl"
MAGISK_MODULE_CONFLICTS="librhash, rhash-dev"
MAGISK_MODULE_REPLACES="librhash, rhash-dev"
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--disable-static --enable-lib-static --enable-lib-shared"

magisk_step_make() {
	CFLAGS="-DOPENSSL_RUNTIME $CPPFLAGS $CFLAGS"
	make -j $MAGISK_MAKE_PROCESSES \
		ADDCFLAGS="$CFLAGS" \
		ADDLDFLAGS="$LDFLAGS"
}

magisk_step_make_install() {
	make install install-pkg-config
	make -C librhash install-lib-headers

	ln -sf $MAGISK_PREFIX/lib/librhash.so.0 $MAGISK_PREFIX/lib/librhash.so
}
