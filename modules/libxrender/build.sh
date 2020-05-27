# X11 package
MAGISK_MODULE_HOMEPAGE=https://xorg.freedesktop.org/
MAGISK_MODULE_DESCRIPTION="X Rendering Extension client library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=0.9.10
MAGISK_MODULE_REVISION=11
MAGISK_MODULE_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXrender-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=c06d5979f86e64cabbde57c223938db0b939dff49fdb5a793a1d3d0396650949
MAGISK_MODULE_DEPENDS="libx11"
MAGISK_MODULE_BUILD_DEPENDS="xorgproto"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
