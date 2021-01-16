MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/fd
MAGISK_MODULE_DESCRIPTION="Simple, fast and user-friendly alternative to find"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=8.2.1
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/fd/archive/v$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=429de7f04a41c5ee6579e07a251c72342cd9cf5b11e6355e861bb3fffa794157
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_post_make_install() {
        mkdir -p $MAGISK_PREFIX/usr/share/man/man1
        cp $(find . -name fd.1) $MAGISK_PREFIX/usr/share/man/man1/
}

