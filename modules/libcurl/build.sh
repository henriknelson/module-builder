MAGISK_MODULE_HOMEPAGE=https://curl.haxx.se/
MAGISK_MODULE_DESCRIPTION="Easy-to-use client-side URL transfer library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=7.65.3
MAGISK_MODULE_SRCURL=https://curl.haxx.se/download/curl-7.65.3.tar.bz2
MAGISK_MODULE_SHA256=0a855e83be482d7bc9ea00e05bdb1551a44966076762f9650959179c89fce509
MAGISK_MODULE_DEPENDS="openssl, libnghttp2, libdl, libcares"
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-ntlm-wb=$MAGISK_PREFIX/bin/ntlm_auth
--with-ca-bundle=$MAGISK_PREFIX/etc/tls/cert.pem
--with-nghttp2
--enable-static
--enable-ares
--without-libidn
--without-libidn2
--without-librtmp
--without-brotli
--with-ssl
--with-pic
"

MAGISK_MODULE_INCLUDE_IN_DEVMODULE="bin/curl-config usr/share/man/man1/curl-config.1"

magisk_step_configure() {
	./configure --prefix=$MAGISK_PREFIX --enable-cross-compile --with-zlib --host=aarch64-linux-android --target=aarch64-linux-android --disable-ldap --disable-ldaps --enable-versioned-symbols --enable-threaded-resolver $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS
}

magisk_step_make() {
	make V=1 curl_LDFLAGS=-all-static -j$(nproc) LIBS+=" -ldl -lcares -lnghttp2"
}
