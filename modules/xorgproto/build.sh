# X11 package
MAGISK_MODULE_HOMEPAGE=https://xorg.freedesktop.org/
MAGISK_MODULE_DESCRIPTION="X.Org X11 Protocol headers"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=2020.1
MAGISK_MODULE_REVISION=4
MAGISK_MODULE_SRCURL=https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2020.1.tar.bz2
MAGISK_MODULE_SHA256=54a153f139035a376c075845dd058049177212da94d7a9707cf9468367b699d2
MAGISK_MODULE_DEPENDS="xorg-util-macros"
MAGISK_MODULE_CONFLICTS="x11-proto"
MAGISK_MODULE_REPLACES="x11-proto"
MAGISK_MODULE_NO_DEVELSPLIT=true
MAGISK_MODULE_PLATFORM_INDEPENDENT=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="-Dlegacy=true"

MAGISK_MODULE_RM_AFTER_INSTALL="
include/X11/extensions/apple*
include/X11/extensions/windows*
include/X11/extensions/XKBgeom.h
lib/pkgconfig/applewmproto.pc
lib/pkgconfig/windowswmproto.pc
"

magisk_step_pre_configure() {
	# Use meson instead of autotools.
	rm -f "$MAGISK_MODULE_SRCDIR"/configure
}
