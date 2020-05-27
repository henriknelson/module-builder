MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/tar/
MAGISK_MODULE_DESCRIPTION="GNU tar for manipulating tar archives"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=1.32
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/tar/tar-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=d0d3ae07f103323be809bc3eac0dcc386d52c5262499fe05511ac4788af1fdd8
MAGISK_MODULE_DEPENDS="libandroid-glob, libiconv"
MAGISK_MODULE_ESSENTIAL=true

# When cross-compiling configure guesses that d_ino in struct dirent only exists
# if triplet matches linux*-gnu*, so we force set it explicitly:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="gl_cv_struct_dirent_d_ino=yes"
# this needed to disable tar's implementation of mkfifoat() so it is possible
# to use own implementation (see patch 'mkfifoat.patch').
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_mkfifoat=yes"

magisk_step_pre_configure() {
	CPPFLAGS+=" -D__USE_FORTIFY_LEVEL=0"
	LDFLAGS+=" -landroid-glob -static"
}
