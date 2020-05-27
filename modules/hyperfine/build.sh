MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/hyperfine
MAGISK_MODULE_DESCRIPTION="A command-line benchmarking tool"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=1.10.0
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/hyperfine/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=b949d6c1a78e9c1c5a7bb6c241fcd51d6faf00bba5719cc312f57b5b301cc854
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_post_make_install() {
        mkdir -p $MAGISK_PREFIX/usr/share/man/man1
        cp $(find . -name hyperfine.1) $MAGISK_PREFIX/usr/share/man/man1/
}
