MAGISK_MODULE_HOMEPAGE=http://caca.zoy.org/wiki/libcaca
MAGISK_MODULE_DESCRIPTION="Graphics library that outputs text instead of pixels"
MAGISK_MODULE_LICENSE="WTFPL"
MAGISK_MODULE_VERSION=1.22.4
MAGISK_MODULE_SRCURL=http://ftp.gnu.org/gnu/groff/groff-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=e78e7b4cb7dec310849004fa88847c44701e8d133b5d4c13057d876c1bad0293
MAGISK_MODULE_DEPENDS="bash, binutils, coreutils, diffutils, gawk"
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--host=aarch64-linux-android
--prefix=$MAGISK_PREFIX
--enable-static
--with-doc=man
"

magisk_step_configure(){
	#CFLAGS=" -static"
	export CFLAGS="$CFLAGS -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0"
	export CXXFLAGS="$CFLAGS"
	LDFLAGS=" --static"
	./configure $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS
}
