MAGISK_MODULE_HOMEPAGE=http://man7.org/linux/man-pages/man3/glob.3.html
MAGISK_MODULE_DESCRIPTION="Shared library for the glob(3) system function"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=0.4
MAGISK_MODULE_BUILD_IN_SRC=yes

mmagisk_step_pre_configure() {
	#export CC=/usr/local/musl/bin/aarch64-linux-musl-gcc
	LDFLAGS+" --static"
}

magisk_step_make_install() {
	cp $MAGISK_MODULE_BUILDER_DIR/glob.h $MAGISK_PREFIX/include/
	#printenv
	$CC $CFLAGS $CPPFLAGS $LDFLAGS $MAGISK_MODULE_BUILDER_DIR/glob.c -shared -o $MAGISK_PREFIX/lib/libandroid-glob.so
}
