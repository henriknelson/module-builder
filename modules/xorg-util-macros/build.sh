# X11 package
MAGISK_MODULE_HOMEPAGE=https://xorg.freedesktop.org/
MAGISK_MODULE_DESCRIPTION="X.Org Autotools macros"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=1.19.2
MAGISK_MODULE_REVISION=6
MAGISK_MODULE_SRCURL=https://xorg.freedesktop.org/releases/individual/util/util-macros-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=d7e43376ad220411499a79735020f9d145fdc159284867e99467e0d771f3e712
MAGISK_MODULE_PLATFORM_INDEPENDENT=true

magisk_step_post_make_install() {
	mkdir -p ${MAGISK_PREFIX}/lib/pkgconfig
	mv ${MAGISK_PREFIX}/usr/share/pkgconfig/xorg-macros.pc ${MAGISK_PREFIX}/lib/pkgconfig/
}
