MAGISK_MODULE_HOMEPAGE=https://libwebsockets.org
MAGISK_MODULE_DESCRIPTION="Lightweight C websockets library"
MAGISK_MODULE_LICENSE="LGPL-2.0"
MAGISK_MODULE_VERSION=4.1.3
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/warmcat/libwebsockets/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=228a0fce3a382b98f3ae140620711c1d855f4dd80ec06f4d08a3c4e093ac3fa8
MAGISK_MODULE_DEPENDS="openssl, libuv, zlib"
MAGISK_MODULE_BREAKS="libwebsockets-dev"
MAGISK_MODULE_REPLACES="libwebsockets-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=RELEASE
-DCMAKE_INSTALL_PREFIX=${MAGISK_PREFIX}
-DCMAKE_FIND_LIBRARY_SUFFIXES=.a
-DCMAKE_EXE_LINKER_FLAGS=-static
-DLWS_WITHOUT_TESTAPPS=ON
-DLWS_WITH_LIBUV=ON
-DLWS_STATIC_PIC=ON
-DLWS_WITH_SHARED=OFF
-DLWS_UNIX_SOCK=ON
-DLWS_IPV6=ON
"
#MAGISK_MODULE_RM_AFTER_INSTALL="lib/pkgconfig/libwebsockets_static.pc"

magisk_step_pre_configure() {
	sed -i 's/ websockets_shared//g' $MAGISK_MODULE_SRCDIR/cmake/libwebsockets-config.cmake.in;
	#export LDFLAGS+=" -lcrypto -lssl -static"
}

magisk_step_post_make_install() {
	local FILENAME="${MAGISK_PREFIX}/lib/cmake/libwebsockets/LibwebsocketsTargets-release.cmake";
	cat $FILENAME;
	sed -i 's/ssl;crypto;//g' $FILENAME;
	cat $FILENAME;
}
