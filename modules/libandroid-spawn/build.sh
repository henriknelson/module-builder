MAGISK_MODULE_HOMEPAGE=http://man7.org/linux/man-pages/man3/posix_spawn.3.html
MAGISK_MODULE_DESCRIPTION="Shared library for the posix_spawn system function"
MAGISK_MODULE_LICENSE="BSD 2-Clause"
MAGISK_MODULE_VERSION=0.2
MAGISK_MODULE_SKIP_SRC_EXTRACT=true
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_REVISION=1

magisk_step_make() {
	$CXX $CFLAGS $CPPFLAGS -I$MAGISK_MODULE_BUILDER_DIR -c $MAGISK_MODULE_BUILDER_DIR/posix_spawn.cpp
	$CXX $LDFLAGS -shared posix_spawn.o -o libandroid-spawn.so
	$AR rcu libandroid-spawn.a posix_spawn.o
}

magisk_step_make_install() {
	install -Dm600 $MAGISK_MODULE_BUILDER_DIR/posix_spawn.h $MAGISK_PREFIX/include/spawn.h
	install -Dm600 libandroid-spawn.a $MAGISK_PREFIX/lib/libandroid-spawn.a
	install -Dm600 libandroid-spawn.so $MAGISK_PREFIX/lib/libandroid-spawn.so
}
