MAGISK_MODULE_HOMEPAGE=https://hisham.hm/htop/
MAGISK_MODULE_DESCRIPTION="Interactive process viewer for Linux"
MAGISK_MODULE_LICENSE="GPL-2.0"
# DO NOT UPDATE
MAGISK_MODULE_VERSION=3.0.2
MAGISK_MODULE_SRCURL=https://github.com/htop-dev/htop/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=b4744a3bea279f2a3725ed8e5e35ffd9cb10d66673bf07c8fe21feb3c4661305
# htop checks setlocale() return value for UTF-8 support, so use libandroid-support.
MAGISK_MODULE_DEPENDS="ncurses, libandroid-support"
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_RM_AFTER_INSTALL="share/applications share/pixmaps"

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_lib_ncursesw6_addnwstr=yes
LIBS=-landroid-support
"

magisk_step_pre_configure() {
	LDFLAGS+=" -static"
	./autogen.sh
}
