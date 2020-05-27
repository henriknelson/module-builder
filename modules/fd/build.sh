MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/fd
MAGISK_MODULE_DESCRIPTION="Simple, fast and user-friendly alternative to find"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=8.1.1
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/fd/archive/v8.1.1.tar.gz
MAGISK_MODULE_SHA256=7b327dc4c2090b34c7fb3e5ac7147f7bbe6266c2d44b182038d36f3b1d347cc1
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_post_make_install() {
        mkdir -p $MAGISK_PREFIX/usr/share/man/man1
        cp $(find . -name fd.1) $MAGISK_PREFIX/usr/share/man/man1/
}

