# X11 package
MAGISK_MODULE_HOMEPAGE=https://xorg.freedesktop.org/
MAGISK_MODULE_DESCRIPTION="X11 miscellaneous extensions library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=1.3.4
MAGISK_MODULE_REVISION=8
MAGISK_MODULE_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXext-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=59ad6fcce98deaecc14d39a672cf218ca37aba617c9a0f691cac3bcd28edf82b
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
MAGISK_MODULE_DEPENDS="libx11, libxau, libxcb, libxdmcp"
MAGISK_MODULE_BUILD_DEPENDS="xorgproto, xorg-util-macros"
