MAGISK_MODULE_HOMEPAGE=https://gmplib.org/
MAGISK_MODULE_DESCRIPTION="Library for arbitrary precision arithmetic"
MAGISK_MODULE_LICENSE="LGPL-3.0"
MAGISK_MODULE_VERSION=6.2.0
MAGISK_MODULE_REVISION=4
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/gmp/gmp-6.2.0.tar.xz
MAGISK_MODULE_SHA256=258e6cd51b3fbdfc185c716d55f82c08aff57df0c6fbd143cf6ed561267a1526
MAGISK_MODULE_BREAKS="libgmp-dev"
MAGISK_MODULE_REPLACES="libgmp-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-cxx"

magisk_step_pre_configure() {
# the cxx tests fail because it won't link properly without this
    CXXFLAGS+=" -L$MAGISK_PREFIX/lib"
}
