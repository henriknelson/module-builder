MAGISK_MODULE_HOMEPAGE=https://github.com/magisk/libandroid-support
MAGISK_MODULE_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=25
MAGISK_MODULE_SRCURL=https://github.com/termux/libandroid-support/archive/v$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=42e7b55c2e5fc91cc0447fa8bea432e7a75ec78b03469330668af17aea56f660
MAGISK_MODULE_PRE_DEPENDS="dpkg (>= 1.19.4-3)"
MAGISK_MODULE_BUILD_IN_SRC=yes
MAGISK_MODULE_ESSENTIAL=yes

magisk_step_make_install() {
	_C_FILES="src/musl-*/*.c"
	_H_FILES="src/musl-*/*.h"
	cp $_H_FILES $MAGISK_PREFIX/include
	CFLAGS="-c"
	$CC --verbose $CFLAGS $CPPFLAGS $LDFLAGS $_C_FILES
	for i in *.o; do
		[ -f "$i" ] || break
		echo "$AR -rcs libandroid-support.a $i"
		$AR -rcs libandroid-support.a $i
	done
	mv libandroid-support.a $MAGISK_PREFIX/lib/
}
