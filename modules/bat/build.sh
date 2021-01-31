MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/bat
MAGISK_MODULE_DESCRIPTION="A cat(1) clone with wings"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=0.17.1
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/bat/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=16d39414e8a3b80d890cfdbca6c0e6ff280058397f4a3066c37e0998985d87c4
# bat calls less with '--RAW-CONTROL-CHARS' which busybox less does not support:
MAGISK_MODULE_DEPENDS="less, zlib-musl"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	#cp /usr/local/musl/aarch64-linux-musl/lib/libc.a /system/lib
	CFLAGS="$CFLAGS -I/system/include"
	LDFLAGS="-L /usr/local/musl/aarch64-linux-musl/lib -lc $LDFLAGS -L/system/lib"

	# See https://github.com/nagisa/rust_libloading/issues/54
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu=""
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/usr/share/man/man1
	mkdir -p $MAGISK_PREFIX/usr/share/assets
	cp $(find . -name bat.1) $MAGISK_PREFIX/usr/share/man/man1/
	cp "$MAGISK_MODULE_SRCDIR/assets/syntaxes.bin" $MAGISK_PREFIX/usr/share/assets/
	cp "$MAGISK_MODULE_SRCDIR/assets/themes.bin" $MAGISK_PREFIX/usr/share/assets/
}
