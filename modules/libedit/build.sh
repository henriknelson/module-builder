MAGISK_MODULE_HOMEPAGE=https://thrysoee.dk/editline/
MAGISK_MODULE_DESCRIPTION="Library providing line editing, history, and tokenization functions"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=20191231-3.1
MAGISK_MODULE_SHA256=dbb82cb7e116a5f8025d35ef5b4f7d4a3cdd0a3909a146a39112095a2d229071
MAGISK_MODULE_SRCURL=https://thrysoee.dk/editline/libedit-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_DEPENDS="libandroid-support, ncurses"
MAGISK_MODULE_BREAKS="libedit-dev"
MAGISK_MODULE_REPLACES="libedit-dev"
MAGISK_MODULE_RM_AFTER_INSTALL="share/man/man7/editline.7 share/man/man3/history.3"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --enable-shared"

magisk_step_pre_configure() {
	CFLAGS+=" -D__STDC_ISO_10646__=201103L -DNBBY=CHAR_BIT"
}
