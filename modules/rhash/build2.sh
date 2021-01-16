BAJSUX_PKG_HOMEPAGE=https://github.com/rhash/RHash
BAJSUX_PKG_DESCRIPTION="Console utility for calculation and verification of magnet links and a wide range of hash sums"
BAJSUX_PKG_LICENSE="MIT"
BAJSUX_PKG_VERSION=1.4.0
BAJSUX_PKG_SRCURL=https://github.com/rhash/RHash/archive/v$BAJSUX_PKG_VERSION.tar.gz
BAJSUX_PKG_SHA256=2ea39540f5c580da0e655f7b483c19e0d31506aed4202d88e8459fa7aeeb8861
BAJSUX_PKG_DEPENDS="openssl"
BAJSUX_PKG_CONFLICTS="librhash, rhash-dev"
BAJSUX_PKG_REPLACES="librhash, rhash-dev"
BAJSUX_PKG_BUILD_IN_SRC=true
BAJSUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static --enable-lib-static --enable-lib-shared"

termux_step_make() {
	CFLAGS="-DOPENSSL_RUNTIME $CPPFLAGS $CFLAGS"
	make -j $BAJSUX_MAKE_PROCESSES \
		ADDCFLAGS="$CFLAGS" \
		ADDLDFLAGS="$LDFLAGS"
}

termux_step_make_install() {
	make install install-pkg-config
	make -C librhash install-lib-headers

	ln -sf $BAJSUX_PREFIX/lib/librhash.so.0 $BAJSUX_PREFIX/lib/librhash.so
}
