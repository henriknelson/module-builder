# X11 package
MAGISK_MODULE_HOMEPAGE=https://xorg.freedesktop.org/
MAGISK_MODULE_DESCRIPTION="X11 Screen Saver extension library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=1.2.3
MAGISK_MODULE_REVISION=10
MAGISK_MODULE_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXScrnSaver-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=f917075a1b7b5a38d67a8b0238eaab14acd2557679835b154cf2bca576e89bf8
MAGISK_MODULE_DEPENDS="libx11, libxau, libxcb, libxdmcp, libxext"
MAGISK_MODULE_BUILD_DEPENDS="xorgproto, xorg-util-macros"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
