MAGISK_MODULE_HOMEPAGE="https://tiswww.case.edu/php/chet/readline/rltop.html"
MAGISK_MODULE_DESCRIPTION="Library that allow users to edit command lines as they are typed in"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_DEPENDS="libandroid-support, ncurses"
MAGISK_MODULE_BREAKS="bash (<< 5.0), readline-dev"
MAGISK_MODULE_REPLACES="readline-dev"
MAGISK_MODULE_VERSION="8.0.1"
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SHA256=e339f51971478d369f8a053a330a190781acb9864cf4c541060f12078948e461
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/readline/readline-8.0.tar.gz
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--with-curses --enable-multibyte bash_cv_wcwidth_broken=no"
MAGISK_MODULE_EXTRA_MAKE_ARGS="SHLIB_LIBS=-lncursesw"
MAGISK_MODULE_CONFFILES="etc/inputrc"

magisk_step_pre_configure() {
	CFLAGS+=" -fexceptions"
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/lib/pkgconfig
	cp readline.pc $MAGISK_PREFIX/lib/pkgconfig/

	mkdir -p $MAGISK_PREFIX/etc
	cp $MAGISK_MODULE_BUILDER_DIR/inputrc $MAGISK_PREFIX/etc/
}
