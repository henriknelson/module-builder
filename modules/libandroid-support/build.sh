MAGISK_MODULE_HOMEPAGE=https://github.com/termux/libandroid-support
MAGISK_MODULE_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=25
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/termux/libandroid-support/archive/v$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=42e7b55c2e5fc91cc0447fa8bea432e7a75ec78b03469330668af17aea56f660
MAGISK_MODULE_PRE_DEPENDS="dpkg (>= 1.19.4-3)"
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_ESSENTIAL=true

magisk_step_make() {
	local c_file

	mkdir objects
	for c_file in $(find src -type f -iname \*.c); do
		$CC $CPPFLAGS $CFLAGS -std=c99 -DNULL=0 -fPIC -Iinclude \
			-c $c_file -o ./objects/$(basename "$c_file").o
	done

	cd objects
	ar rcu ../libandroid-support.a
	$CC $LDFLAGS -shared -o ../libandroid-support.so *.o
}

magisk_step_make_install() {
	install -Dm600 libandroid-support.a $MAGISK_PREFIX/lib/libandroid-support.a
	install -Dm600 libandroid-support.so $MAGISK_PREFIX/lib/libandroid-support.so
}
