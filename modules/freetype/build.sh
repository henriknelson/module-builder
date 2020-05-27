MAGISK_MODULE_HOMEPAGE=https://www.freetype.org
MAGISK_MODULE_DESCRIPTION="Software font engine capable of producing high-quality output"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.10.2
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://download.savannah.gnu.org/releases/freetype/freetype-2.10.2.tar.xz
MAGISK_MODULE_SHA256=1543d61025d2e6312e0a1c563652555f17378a204a61e99928c9fcef030a2d8b
MAGISK_MODULE_DEPENDS="libbz2, libpng, zlib"
MAGISK_MODULE_BREAKS="freetype-dev"
MAGISK_MODULE_REPLACES="freetype-dev"
# Use with-harfbuzz=no to avoid circular dependency between freetype and harfbuzz:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--with-harfbuzz=no"
# not install these files anymore so install them manually.
magisk_step_post_make_install() {
	install -Dm700 freetype-config $MAGISK_PREFIX/bin/freetype-config
	install -Dm600 ../src/docs/freetype-config.1 $MAGISK_PREFIX/share/man/man1/freetype-config.1
}

