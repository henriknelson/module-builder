MAGISK_MODULE_HOMEPAGE=https://www.libarchive.org/
MAGISK_MODULE_DESCRIPTION="Multi-format archive and compression library"
MAGISK_MODULE_LICENSE="BSD 2-Clause"
MAGISK_MODULE_VERSION=3.4.3
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SRCURL=https://github.com/libarchive/libarchive/releases/download/v3.4.3/libarchive-3.4.3.tar.gz
MAGISK_MODULE_SHA256=ee1e749213c108cb60d53147f18c31a73d6717d7e3d2481c157e1b34c881ea39
MAGISK_MODULE_DEPENDS="libbz2, libiconv, liblzma, libxml2, openssl, zlib"
MAGISK_MODULE_BREAKS="libarchive-dev"
MAGISK_MODULE_REPLACES="libarchive-dev"

# --without-nettle to use openssl instead:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--prefix=/system
--disable-shared
--enable-static
--without-nettle
--without-lz4
--without-zstd
--without-xml2
"

magisk_step_pre_configure(){
	export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR
}
