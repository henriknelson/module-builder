MAGISK_MODULE_HOMEPAGE=http://man7.org/linux/man-pages/man3/glob.3.html
MAGISK_MODULE_DESCRIPTION="Shared library for the glob(3) system function"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=0.6
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_pre_configure() {
	cp $MAGISK_MODULE_BUILDER_DIR/* $MAGISK_MODULE_SRCDIR
	CC=$CC
}

magisk_step_make_install() {
	cp $MAGISK_MODULE_SRCDIR/libres.a /system/lib
}
