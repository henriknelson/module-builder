MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/fd
MAGISK_MODULE_DESCRIPTION="Simple, fast and user-friendly alternative to find"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=8.0.0
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/fd/archive/v$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=fba93204c10266317e0981914c630b08e12cd322c75ff2a2e504ff1dce17d557
MAGISK_MODULE_BUILD_IN_SRC=true

termux_step_post_make_install() {
	mkdir -p  $MAGISK_PREFIX/share/man/man1
	cp $MAGISK_MODULE_SRCDIR/doc/fd.1 $MAGISK_PREFIX/share/man/man1/fd.1
}
