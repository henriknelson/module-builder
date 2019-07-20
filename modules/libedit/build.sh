MAGISK_MODULE_HOMEPAGE=https://thrysoee.dk/editline/
MAGISK_MODULE_DESCRIPTION="Library providing line editing, history, and tokenization functions"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=20190324-3.1
MAGISK_MODULE_SHA256=ac8f0f51c1cf65492e4d1e3ed2be360bda41e54633444666422fbf393bba1bae
MAGISK_MODULE_SRCURL=https://thrysoee.dk/editline/libedit-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_DEPENDS="libandroid-support, ncurses"
MAGISK_MODULE_RM_AFTER_INSTALL="share/man/man7/editline.7 share/man/man3/history.3"

magisk_step_pre_configure() {
	CFLAGS+=" -D__STDC_ISO_10646__=201103L -DNBBY=CHAR_BIT"
}
