MAGISK_MODULE_HOMEPAGE=http://caca.zoy.org/wiki/libcaca
MAGISK_MODULE_DESCRIPTION="Graphics library that outputs text instead of pixels"
MAGISK_MODULE_LICENSE="WTFPL"
MAGISK_MODULE_VERSION=0.99.beta19
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SRCURL=http://fossies.org/linux/privat/libcaca-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4
MAGISK_MODULE_DEPENDS="libc++, ncurses, zlib"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--disable-shared --enable-static --disable-python --disable-java --disable-ruby --disable-doc"

magisk_step_post_configure() {
	if [ $MAGISK_ARCH = x86_64 ]; then
		# Remove troublesome asm usage:
		perl -p -i -e 's/#define HAVE_FLDLN2 1//' $MAGISK_MODULE_BUILDDIR/config.h
	fi
}
