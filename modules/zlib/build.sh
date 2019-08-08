MAGISK_MODULE_HOMEPAGE=https://www.zlib.net/
MAGISK_MODULE_DESCRIPTION="Compression library implementing the deflate compression method found in gzip and PKZIP"
MAGISK_MODULE_LICENSE="ZLIB"
MAGISK_MODULE_VERSION=1.2.11
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SHA256=4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066
MAGISK_MODULE_SRCURL=https://www.zlib.net/zlib-$MAGISK_MODULE_VERSION.tar.xz
MAGISK_MODULE_DEVMODULE_BREAKS="ndk-sysroot (<< 19b-3)"
MAGISK_MODULE_DEVMODULE_REPLACES="ndk-sysroot (<< 19b-3)"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_configure() {
	./configure --prefix=$MAGISK_PREFIX --static --archs="-arch aarch64"
}
