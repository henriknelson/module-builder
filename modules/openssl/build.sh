MAGISK_MODULE_HOMEPAGE=https://www.openssl.org/
MAGISK_MODULE_DESCRIPTION="Library implementing the SSL and TLS protocols as well as general purpose cryptography functions"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_DEPENDS="ca-certificates"
MAGISK_MODULE_VERSION=1.1.1c
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SHA256=f6fb3079ad15076154eda9413fed42877d668e7069d9b87396d0804fdb3f4c90
MAGISK_MODULE_SRCURL=https://www.openssl.org/source/openssl-${MAGISK_MODULE_VERSION/\~/-}.tar.gz
MAGISK_MODULE_CONFFILES="etc/tls/openssl.cnf"
MAGISK_MODULE_RM_AFTER_INSTALL="bin/c_rehash etc/ssl/misc"
MAGISK_MODULE_BUILD_IN_SRC=yes
MAGISK_MODULE_CONFLICTS="libcurl (<< 7.61.0-1)"
MAGISK_MODULE_BREAKS="openssl-tool (<< 1.1.1b-1)"
MAGISK_MODULE_REPLACES="openssl-tool (<< 1.1.1b-1)"

magisk_step_configure() {
	CFLAGS+=" -DNO_SYSLOG"
	if [ $MAGISK_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi

	perl -p -i -e "s@MAGISK_CFLAGS@$CFLAGS@g" Configure
	rm -Rf $MAGISK_PREFIX/lib/libcrypto.* $MAGISK_PREFIX/lib/libssl.*
	test $MAGISK_ARCH = "arm" && MAGISK_OPENSSL_PLATFORM="android-arm"
	test $MAGISK_ARCH = "aarch64" && MAGISK_OPENSSL_PLATFORM="android-arm64"
	test $MAGISK_ARCH = "i686" && MAGISK_OPENSSL_PLATFORM="android-x86"
	test $MAGISK_ARCH = "x86_64" && MAGISK_OPENSSL_PLATFORM="android-x86_64"
	# If enabling zlib-dynamic we need "zlib-dynamic" instead of "no-comp no-dso":
	./Configure $MAGISK_OPENSSL_PLATFORM \
		--prefix=$MAGISK_PREFIX \
		--openssldir=$MAGISK_PREFIX/etc/tls \
		static \
		no-ssl \
		no-comp \
		no-dso \
		no-hw \
		no-srp \
		no-tests
}

magisk_step_make() {
	make depend
	make -j $MAGISK_MAKE_PROCESSES all
}

magisk_step_make_install() {
	# "install_sw" instead of "install" to not install man pages:
	make -j 1 install_sw MANDIR=$MAGISK_PREFIX/share/man MANSUFFIX=.ssl

	mkdir -p $MAGISK_PREFIX/etc/tls/
	cp apps/openssl.cnf $MAGISK_PREFIX/etc/tls/openssl.cnf
}
