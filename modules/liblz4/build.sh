MAGISK_MODULE_HOMEPAGE=https://lz4.github.io/lz4/
MAGISK_MODULE_DESCRIPTION="Fast LZ compression algorithm library"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=1.9.2
MAGISK_MODULE_SRCURL=https://github.com/lz4/lz4/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=658ba6191fa44c92280d4aa2c271b0f4fbc0e34d249578dd05e50e76d0e5efcc
MAGISK_MODULE_BREAKS="liblz4-dev"
MAGISK_MODULE_REPLACES="liblz4-dev"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	MAGISK_MODULE_SRCDIR+=lib
}

# Do not execute this step since on `make install` it will
# recompile libraries & tools again.
magisk_step_make() {
	:
}
