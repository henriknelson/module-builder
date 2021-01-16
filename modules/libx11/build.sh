# X11 package
MAGISK_MODULE_HOMEPAGE=https://xorg.freedesktop.org/
MAGISK_MODULE_DESCRIPTION="X11 client-side library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=1.6.12
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libX11-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=f108227469419ac04d196df0f3b80ce1f7f65059bb54c0de811f4d8e03fd6ec7
MAGISK_MODULE_DEPENDS="libandroid-support, libxcb"
MAGISK_MODULE_BUILD_DEPENDS="xorgproto, xorg-util-macros, xtrans"
MAGISK_MODULE_RECOMMENDS="xorg-xauth"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull --enable-shared"

magisk_step_post_make_install() {
	ln -sfr "${MAGISK_PREFIX}/lib/libX11.so" "${MAGISK_PREFIX}/lib/libX11.so.6"
}
