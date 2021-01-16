MAGISK_MODULE_HOMEPAGE=https://www.freetype.org
MAGISK_MODULE_DESCRIPTION="Software font engine capable of producing high-quality output"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.10.3
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://download.savannah.gnu.org/releases/freetype/freetype-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=c22244bc766b2d8152f22db7370965431dcb1e408260428208c24984f78e6659
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

