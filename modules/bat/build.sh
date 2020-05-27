MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/bat
MAGISK_MODULE_DESCRIPTION="A cat(1) clone with wings"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=0.15.4
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/bat/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=03b7c8ad6221ca87cecd71f9e3e2167f04f750401e2d3dcc574183aabeb76a8b
# bat calls less with '--RAW-CONTROL-CHARS' which busybox less does not support:
MAGISK_MODULE_DEPENDS="less, zlib"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	CFLAGS="$CFLAGS -I/system/include"
	LDFLAGS="-lz $LDFLAGS -L/system/lib"
	# $CPPFLAGS"

	# See https://github.com/nagisa/rust_libloading/issues/54
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu=""
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/usr/share/man/man1
	cp $(find . -name bat.1) $MAGISK_PREFIX/usr/share/man/man1/
}
