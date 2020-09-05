MAGISK_MODULE_HOMEPAGE=https://the.exa.website
MAGISK_MODULE_DESCRIPTION="A modern replacement for ls"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=0.9.0
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/ogham/exa/archive/058b4a57bdb1e25cbdacc0fbd1eefc09bc5f1e95.zip
MAGISK_MODULE_SHA256=9931ad1c593096e69a1f0f7615e3857b1d422b7e74f63408385c663aeb2c12db
MAGISK_MODULE_DEPENDS="zlib"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--no-default-features --features default"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	rm $MAGISK_MODULE_SRCDIR/Makefile
	magisk_setup_rust

	CFLAGS="$CFLAGS -I/system/include"
	LDFLAGS+=" -lz -static"
	cargo update
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/usr/share/man/man1
	cp $MAGISK_MODULE_SRCDIR/contrib/man/exa.1 $MAGISK_PREFIX/usr/share/man/man1/
}
