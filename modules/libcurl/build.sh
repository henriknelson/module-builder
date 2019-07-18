MAGISK_MODULE_HOMEPAGE=https://curl.haxx.se/
MAGISK_MODULE_DESCRIPTION="Easy-to-use client-side URL transfer library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=7.65.1
MAGISK_MODULE_SRCURL=https://curl.haxx.se/download/curl-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=cbd36df60c49e461011b4f3064cff1184bdc9969a55e9608bf5cadec4686e3f7
MAGISK_MODULE_DEPENDS="openssl, libnghttp2, libcares"
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

MAGISK_MODULE_INCLUDE_IN_DEVMODULE="bin/curl-config share/man/man1/curl-config.1"

# Starting with version 7.62 curl started enabling http/2 by default.
# Support for http/2 as added in version 1.4.8-8 of the apt package, so we
# conflict with previous versions to avoid broken installations.
#MAGISK_MODULE_CONFLICTS="apt (<< 1.4.8-8)"

#mmagisk_step_configure() {
#	./configure --prefix $MAGISK_PREFIX --host=aarch64-linux-android --target=aarch64-linux-android --includedir=/system/include --libdir=/system/lib $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS CC=$CC
#}


#magisk_step_pre_configure() {
#	export PATH=/usr/local/musl/bin:$PATH
#	#export CROSS_COMPILE=aarch64-linux-musl
#        export CC=/usr/local/musl/bin/aarch64-linux-musl-gcc
#	#export CPP=/usr/local/musl/bin/aarch64-linux-musl-cpp
#        #export LD=/usr/local/musl/bin/aarch64-linux-musl-ld
#        #LDFLAGS+="${LDFLAGS} --static"
#}

#magisk_step_make_install() {
#        $CC -I/system/include -I$MAGISK_MODULE_SRCDIR/src $CFLAGS $CPPFLAGS $LDFLAGS -Wall -Wextra -fPIC -shared $MAGISK_MODULE_SRCDIR/src/*.c -lcurl -o $MAGISK_PREFIX/lib/libcurl.so
#        mkdir -p $MAGISK_PREFIX/include/
#        cp $MAGISK_MODULE_BUILDER_DIR/*.h $MAGISK_PREFIX/include/
#}

magisk_step_configure() {
	#export CPPFLAGS=" -I$MAGISK_PREFIX/include"
	#export LDFLAGS="-static -L$MAGISK_PREFIX/lib"
	./configure --prefix=$MAGISK_PREFIX --enable-cross-compile --with-zlib --host=aarch64-linux-android --target=aarch64-linux-android --disable-ldap --disable-ldaps --enable-versioned-symbols --enable-threaded-resolver $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS
	#LIBS+=" -lpthread -ldl"
}

magisk_step_make() {
	make V=1 curl_LDFLAGS=-all-static -j$(nproc) LIBS+=" -ldl -lcares -lnghttp2"
}
