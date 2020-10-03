MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/bat
MAGISK_MODULE_DESCRIPTION="A cat(1) clone with wings"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=0.16.0
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/bat/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=4db85abfaba94a5ff601d51b4da8759058c679a25b5ec6b45c4b2d85034a5ad3
# bat calls less with '--RAW-CONTROL-CHARS' which busybox less does not support:
MAGISK_MODULE_DEPENDS="less, zlib"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	cp /usr/local/musl/aarch64-linux-musl/lib/libc.a /system/lib
	CFLAGS="$CFLAGS -I/system/include"
	LDFLAGS="-lc -lz $LDFLAGS -L/system/lib"
	# $CPPFLAGS"

	# See https://github.com/nagisa/rust_libloading/issues/54
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu=""
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/usr/share/man/man1
	cp $(find . -name bat.1) $MAGISK_PREFIX/usr/share/man/man1/
}
