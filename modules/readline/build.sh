MAGISK_MODULE_HOMEPAGE="https://tiswww.case.edu/php/chet/readline/rltop.html"
MAGISK_MODULE_DESCRIPTION="Library that allow users to edit command lines as they are typed in"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_DEPENDS="libandroid-support, ncurses"
MAGISK_MODULE_BREAKS="bash (<< 5.0), readline-dev"
MAGISK_MODULE_REPLACES="readline-dev"
_MAIN_VERSION=8.0
_PATCH_VERSION=4
MAGISK_MODULE_VERSION=$_MAIN_VERSION.$_PATCH_VERSION
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/readline/readline-${_MAIN_VERSION}.tar.gz
MAGISK_MODULE_SHA256=e339f51971478d369f8a053a330a190781acb9864cf4c541060f12078948e461
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--with-curses --enable-multibyte bash_cv_wcwidth_broken=no --enable-shared"
MAGISK_MODULE_EXTRA_MAKE_ARGS="SHLIB_LIBS=-lncursesw"
MAGISK_MODULE_CONFFILES="etc/inputrc"

magisk_step_pre_configure() {
	declare -A PATCH_CHECKSUMS
	PATCH_CHECKSUMS[001]=d8e5e98933cf5756f862243c0601cb69d3667bb33f2c7b751fe4e40b2c3fd069
	PATCH_CHECKSUMS[002]=36b0febff1e560091ae7476026921f31b6d1dd4c918dcb7b741aa2dad1aec8f7
	PATCH_CHECKSUMS[003]=94ddb2210b71eb5389c7756865d60e343666dfb722c85892f8226b26bb3eeaef
	PATCH_CHECKSUMS[004]=b1aa3d2a40eee2dea9708229740742e649c32bb8db13535ea78f8ac15377394c
	for PATCH_NUM in $(seq -f '%03g' ${_PATCH_VERSION}); do
		PATCHFILE=$MAGISK_MODULE_CACHEDIR/readline_patch_${PATCH_NUM}.patch
		magisk_download \
			"http://mirrors.kernel.org/gnu/readline/readline-$_MAIN_VERSION-patches/readline${_MAIN_VERSION/./}-$PATCH_NUM" \
			$PATCHFILE \
			${PATCH_CHECKSUMS[$PATCH_NUM]}
		patch -p0 -i $PATCHFILE
	done

	CFLAGS+=" -fexceptions"
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/lib/pkgconfig
	cp readline.pc $MAGISK_PREFIX/lib/pkgconfig/

	mkdir -p $MAGISK_PREFIX/etc
	cp $MAGISK_MODULE_BUILDER_DIR/inputrc $MAGISK_PREFIX/etc/
}
