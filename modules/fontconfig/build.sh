MAGISK_MODULE_HOMEPAGE=https://www.freedesktop.org/wiki/Software/fontconfig/
MAGISK_MODULE_DESCRIPTION="Library for configuring and customizing font access"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=2.13.1
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SRCURL=https://www.freedesktop.org/software/fontconfig/release/fontconfig-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=f655dd2a986d7aa97e052261b36aa67b0a64989496361eca8d604e6414006741
MAGISK_MODULE_DEPENDS="freetype, libxml2, libpng, libuuid, ttf-dejavu, zlib"
MAGISK_MODULE_BREAKS="fontconfig-dev"
MAGISK_MODULE_REPLACES="fontconfig-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-libxml2
--enable-iconv=no
--disable-docs
--with-default-fonts=/system/fonts
--with-add-fonts=$MAGISK_PREFIX/share/fonts
"
