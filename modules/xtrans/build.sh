# X11 package
MAGISK_MODULE_HOMEPAGE=https://xorg.freedesktop.org/
MAGISK_MODULE_DESCRIPTION="X transport library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=1.4.0
MAGISK_MODULE_REVISION=6
MAGISK_MODULE_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/xtrans-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=377c4491593c417946efcd2c7600d1e62639f7a8bbca391887e2c4679807d773
MAGISK_MODULE_NO_DEVELSPLIT=true
MAGISK_MODULE_PLATFORM_INDEPENDENT=true

magisk_step_post_make_install() {
	mkdir -p ${MAGISK_PREFIX}/lib/pkgconfig
	mv ${MAGISK_PREFIX}/usr/share/pkgconfig/xtrans.pc ${MAGISK_PREFIX}/lib/pkgconfig
}
