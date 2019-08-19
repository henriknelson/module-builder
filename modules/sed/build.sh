MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/sed/
MAGISK_MODULE_DESCRIPTION="GNU stream editor for filtering/transforming text"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=4.7
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/sed/sed-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=2885768cd0a29ff8d58a6280a270ff161f6a3deb5690b2be6c49f46d4c67bd6a
MAGISK_MODULE_ESSENTIAL=yes
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_pre_configure() {
	CFLAGS+=" -D__USE_FORTIFY_LEVEL=2"
}

magisk_step_post_configure() {
	touch -d "next hour" $MAGISK_MODULE_SRCDIR/doc/sed.1
}
