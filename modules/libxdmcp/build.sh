# X11 package
MAGISK_MODULE_HOMEPAGE=https://xorg.freedesktop.org/
MAGISK_MODULE_DESCRIPTION="X11 Display Manager Control Protocol library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=1.1.3
MAGISK_MODULE_REVISION=8
MAGISK_MODULE_SRCURL=https://ftp.osuosl.org/pub/blfs/svn/Xorg/libXdmcp-${MAGISK_MODULE_VERSION}.tar.bz2
#https://xorg.freedesktop.org/archive/individual/lib/libXdmcp-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=20523b44aaa513e17c009e873ad7bbc301507a3224c232610ce2e099011c6529
MAGISK_MODULE_BUILD_DEPENDS="xorgproto, xorg-util-macros"
