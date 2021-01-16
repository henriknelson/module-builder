MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/lscolors
MAGISK_MODULE_DESCRIPTION="A command-line benchmarking tool"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=0.7.1
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/lscolors/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=2cab9b2cee80f86ef84a60375e8c54e77d1c94ea739969efbf18d5e317fa5523
MAGISK_MODULE_BUILD_IN_SRC=yes

mmagisk_step_post_make_install() {
        mkdir -p $MAGISK_PREFIX/usr/share/man/man1
        cp $(find . -name lscolors.1) $MAGISK_PREFIX/usr/share/man/man1/
}
