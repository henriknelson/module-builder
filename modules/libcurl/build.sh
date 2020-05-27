MAGISK_MODULE_HOMEPAGE=https://curl.haxx.se/
MAGISK_MODULE_DESCRIPTION="Easy-to-use client-side URL transfer library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=7.70.0
MAGISK_MODULE_SRCURL=https://curl.haxx.se/download/curl-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=a50bfe62ad67a24f8b12dd7fd655ac43a0f0299f86ec45b11354f25fbb5829d0
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
