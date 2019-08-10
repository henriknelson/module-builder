MAGISK_MODULE_HOMEPAGE=https://github.com/magisk/libandroid-support
MAGISK_MODULE_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=25
MAGISK_MODULE_SRCURL=https://github.com/termux/libandroid-support/archive/v$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=42e7b55c2e5fc91cc0447fa8bea432e7a75ec78b03469330668af17aea56f660
MAGISK_MODULE_PRE_DEPENDS="dpkg (>= 1.19.4-3)"
MAGISK_MODULE_BUILD_IN_SRC=yes
MAGISK_MODULE_ESSENTIAL=yes

magisk_step_pre_configure() {
	MUSL=/usr/local/musl/bin
	TARGET=aarch64-linux-musl
	export CC=$MUSL/$TARGET-gcc
	export LD=$MUSL/$TARGET-ld
}

magisk_step_make_install() {
	_C_FILES="src/musl-*/*.c"
	#CFLAGS="$CFLAGS -static"
	#LDFLAGS=" --static"
	#$CC $CFLAGS -std=c99 -DNULL=0 $CPPFLAGS $LDFLAGS \
	#	-Iinclude \
	#	$_C_FILES \
	#	-shared -static -fPIC \
	#	-o $MAGISK_PREFIX/lib/libandroid-support.so
	$CC --verbose -Iinclude -I$MAGISK_PREFIX/include -L$MAGISK_PREFIX/lib $_C_FILES -shared -static -fPIC -o $MAGISK_PREFIX/lib/libandroid-support.a
}
