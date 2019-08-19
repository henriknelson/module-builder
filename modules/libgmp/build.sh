MAGISK_MODULE_HOMEPAGE=https://gmplib.org/
MAGISK_MODULE_DESCRIPTION="Library for arbitrary precision arithmetic"
MAGISK_MODULE_LICENSE="LGPL-3.0"
MAGISK_MODULE_VERSION=6.1.2
MAGISK_MODULE_REVISION=4
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/gmp/gmp-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912
MAGISK_MODULE_BREAKS="libgmp-dev"
MAGISK_MODULE_REPLACES="libgmp-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-cxx"

magisk_step_pre_configure() {
# the cxx tests fail because it won't link properly without this
    CXXFLAGS+=" -L$MAGISK_PREFIX/lib"
}
