MAGISK_MODULE_HOMEPAGE=https://curl.haxx.se/
MAGISK_MODULE_DESCRIPTION="Easy-to-use client-side URL transfer library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=7.75.0
MAGISK_MODULE_SRCURL=https://curl.haxx.se/download/curl-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=50552d4501c178e4cc68baaecc487f466a3d6d19bbf4e50a01869effb316d026
MAGISK_MODULE_DEPENDS="openssl, libnghttp2, libdl, c-ares"
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-ntlm-wb=$MAGISK_PREFIX/bin/ntlm_auth
--with-ca-bundle=$MAGISK_PREFIX/etc/tls/cert.pem
--with-ca-path=$MAGISK_PREFIX/etc/tls/certs
--with-nghttp2
--enable-static
--disable-shared
--enable-ares
--without-libidn
--without-libidn2
--without-librtmp
--without-brotli
--with-ssl
--with-pic
--with-openssl="/system"
"

MAGISK_MODULE_INCLUDE_IN_DEVMODULE="bin/curl-config usr/share/man/man1/curl-config.1"

magisk_step_configure() {
	export CFLAGS+=" -static"
	export CPPFLAGS=" -DCURL_STATICLIB -DCARES_STATICLIB=1"
	export LDFLAGS=" $LDFLAGS -static"
	export LIBS=" -lssl -lcrypto -lcares -lz -ldl"
	#"-lcares -lz -ldl -lssl -lcrypto -lnghttp2 -lz -ldl"
	#-lssl -lcrypto"
	./configure --prefix=$MAGISK_PREFIX --enable-cross-compile --with-zlib --host=aarch64-linux-android --target=aarch64-linux-android --disable-ldap --disable-ldaps --enable-versioned-symbols --enable-threaded-resolver $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS
}

magisk_step_make() {
	make V=2 curl_LDFLAGS=-all-static -j$(nproc) 
	#LIBS=" -ldl -lz -lnghttp2 -lssl -lcrypto -ldl -lcares -lz"
}
