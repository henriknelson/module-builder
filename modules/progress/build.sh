MAGISK_MODULE_HOMEPAGE=https://github.com/Xfennec/progress
MAGISK_MODULE_DESCRIPTION="Linux tool to show progress for cp, mv, dd and more"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=0.15
MAGISK_MODULE_SRCURL=https://github.com/Xfennec/progress/archive/v$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=1ed0ac65a912ef1aa605d524eaddaacae92079cf71182096a7c65cbc61687d1b
MAGISK_MODULE_DEPENDS="ncurses"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	LDFLAGS+=" -static"
}
