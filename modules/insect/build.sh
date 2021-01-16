MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/insect
MAGISK_MODULE_DESCRIPTION="A command-line benchmarking tool"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=5.6.0
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/insect/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=31d6cfd1782a8a910c0fd24dc9191e54df57e213cae4195e0ff34f42e29979d0
MAGISK_MODULE_BUILD_IN_SRC=yes

mmagisk_step_post_make_install() {
        mkdir -p $MAGISK_PREFIX/usr/share/man/man1
        cp $(find . -name insect.1) $MAGISK_PREFIX/usr/share/man/man1/
}
