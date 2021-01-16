MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/global/
MAGISK_MODULE_DESCRIPTION="Source code search and browse tools"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=6.6.5
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/global/global-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=9c3730bd9e975d94231f3402d5526b79c0b23cc665d624c9829c948dfad37b83
MAGISK_MODULE_DEPENDS="ncurses"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_posix1_2008_realpath=yes
--with-posix-sort=$MAGISK_PREFIX/bin/sort
--with-ncurses=$MAGISK_PREFIX
--disable-shared
--enable-static
"

magisk_step_pre_configure() {
	echo "Setting up static build.."
	#export PATH=/usr/local/musl/bin:$PATH
	#export CC=/usr/local/musl/bin/aarch64-linux-musl-cc
	#MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --host=aarch64-linux-android --target=aarch64-linux-android"
	#CFLAGS+=" -static"
	LDFLAGS=" --static"
	#if [ "$MAGISK_DEBUG" == "true" ]; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives this error:
		# /home/builder/.magisk-build/_lib/16-aarch64-21-v3/bin/../sysroot/usr/include/bits/fortify/string.h:79:26: error: use of undeclared identifier '__USE_FORTIFY_LEVEL'
	#	export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	#fi
}
