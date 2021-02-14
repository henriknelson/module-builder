MAGISK_MODULE_HOMEPAGE=https://github.com/facebook/zstd
MAGISK_MODULE_DESCRIPTION="Zstandard compression."
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=1.4.8
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/facebook/zstd/archive/v$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=f176f0626cb797022fbf257c3c644d71c1c747bb74c32201f9203654da35e9fa
MAGISK_MODULE_DEPENDS="liblzma, zlib"
MAGISK_MODULE_BREAKS="zstd-dev"
MAGISK_MODULE_REPLACES="zstd-dev"
MAGISK_MODULE_BUILD_IN_SRC=true
NMAGISK_MODULE_EXTRA_CONFIGURATION_ARGS="
--disable-shared
--enable-static
"

mmagisk_step_pre_configure() {
	export CFLAGS=" $CFLAGS -static"
	export LDFLAGS=" $LDFLAGS -lz -static"
	export LIBS=" -lz"
}
