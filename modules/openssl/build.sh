MAGISK_MODULE_HOMEPAGE=https://www.openssl.org/
MAGISK_MODULE_DESCRIPTION="Library implementing the SSL and TLS protocols as well as general purpose cryptography functions"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.1.1h
MAGISK_MODULE_SRCURL=https://www.openssl.org/source/openssl-${MAGISK_MODULE_VERSION/\~/-}.tar.gz
MAGISK_MODULE_SHA256=5c9ca8774bd7b03e5784f26ae9e9e6d749c9da2438545077e6b3d755a06595d9
MAGISK_MODULE_DEPENDS="libandroid-support, ca-certificates, zlib"
MAGISK_MODULE_CONFFILES="etc/tls/openssl.cnf"
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_CONFLICTS="libcurl (<< 7.61.0-1)"
MAGISK_MODULE_BREAKS="openssl-tool (<< 1.1.1b-1), openssl-dev"
MAGISK_MODULE_REPLACES="openssl-tool (<< 1.1.1b-1), openssl-dev"

magisk_step_configure() {
	CFLAGS+=" -DNO_SYSLOG"
	LDFLAGS+=" -ldl"
	perl -p -i -e "s@MAGISK_CFLAGS@$CFLAGS@g" Configure
	rm -Rf $MAGISK_PREFIX/lib/libcrypto.* $MAGISK_PREFIX/lib/libssl.*
	test $MAGISK_ARCH = "arm" && MAGISK_OPENSSL_PLATFORM="android-arm"
	test $MAGISK_ARCH = "aarch64" && MAGISK_OPENSSL_PLATFORM="android-arm64"
	test $MAGISK_ARCH = "i686" && MAGISK_OPENSSL_PLATFORM="android-x86"
	test $MAGISK_ARCH = "x86_64" && MAGISK_OPENSSL_PLATFORM="android-x86_64"

	LIBS='-ldl -lpthread' ./Configure $MAGISK_OPENSSL_PLATFORM \
		--prefix=$MAGISK_PREFIX \
		--openssldir=$MAGISK_PREFIX/etc/tls \
		no-shared \
		no-ssl \
		no-hw \
		no-srp \
		no-tests
}

magisk_step_make() {
	make V=1 depend
	make V=1 -j $MAGISK_MAKE_PROCESSES all
}

magisk_step_make_install() {
	# "install_sw" instead of "install" to not install man pages:
	make V=1 -j 1 install_sw MANDIR=$MAGISK_PREFIX/usr/share/man MANSUFFIX=.ssl

	mkdir -p $MAGISK_PREFIX/etc/tls/

	cp apps/openssl.cnf $MAGISK_PREFIX/etc/tls/openssl.cnf

	sed "s|@MAGISK_PREFIX@|$MAGISK_PREFIX|g" \
		$MAGISK_MODULE_BUILDER_DIR/add-trusted-certificate \
		> $MAGISK_PREFIX/bin/add-trusted-certificate
	chmod 700 $MAGISK_PREFIX/bin/add-trusted-certificate
}

#export PATH=/usr/local/musl/bin:$PATH
#export PREFIX=/usr/local/musl/bin/aarch64-linux-musl
#env CC=${PREFIX}-gcc AR=${PREFIX}-ar RANLIB=${PREFIX}-ranlib C_INCLUDE_PATH=/usr/local/musl/aarch64-linux-musl/include
