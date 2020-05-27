MAGISK_MODULE_HOMEPAGE=https://github.com/termux/libandroid-support
MAGISK_MODULE_DESCRIPTION="Library extending the Android C library (Bionic) for additional multibyte, locale and math support"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=26
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/termux/libandroid-support/archive/v26.tar.gz
MAGISK_MODULE_SHA256=ae2a62547f027624aec8442a0cb724b41de5f60d56d52634f605c566a34cde9b
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
