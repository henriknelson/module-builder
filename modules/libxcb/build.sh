# X11 package
MAGISK_MODULE_HOMEPAGE=https://xcb.freedesktop.org/
MAGISK_MODULE_DESCRIPTION="X11 client-side library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=1.14
MAGISK_MODULE_SRCURL=https://ftp.osuosl.org/pub/blfs/svn/Xorg/libxcb-$MAGISK_MODULE_VERSION.tar.xz
#https://xorg.freedesktop.org/archive/individual/lib/libxcb-$MAGISK_MODULE_VERSION.tar.xz
MAGISK_MODULE_SHA256=a55ed6db98d43469801262d81dc2572ed124edc3db31059d4e9916eb9f844c34
MAGISK_MODULE_DEPENDS="libxau, libxdmcp"
MAGISK_MODULE_BUILD_DEPENDS="xcb-proto, xorg-util-macros"
MAGISK_MODULE_RECOMMENDS="xorg-xauth"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS=" --enable-shared"
