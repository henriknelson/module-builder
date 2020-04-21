MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/sed/
MAGISK_MODULE_DESCRIPTION="GNU stream editor for filtering/transforming text"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=4.8
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/sed/sed-4.8.tar.xz
MAGISK_MODULE_SHA256=f79b0cfea71b37a8eeec8490db6c5f7ae7719c35587f21edb0617f370eeff633
MAGISK_MODULE_ESSENTIAL=yes
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_pre_configure() {
	CFLAGS+=" -D__USE_FORTIFY_LEVEL=2"
}

magisk_step_post_configure() {
	touch -d "next hour" $MAGISK_MODULE_SRCDIR/doc/sed.1
}
