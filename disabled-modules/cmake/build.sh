MAGISK_MODULE_HOMEPAGE=https://cmake.org/
MAGISK_MODULE_DESCRIPTION="Family of tools designed to build, test and package software"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=3.17.2
MAGISK_MODULE_SRCURL=https://www.cmake.org/files/v3.17/cmake-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=fc77324c4f820a09052a7785549b8035ff8d3461ded5bbd80d252ae7d1cd3aa5
MAGISK_MODULE_DEPENDS="libarchive, libc++, libcurl, libexpat, jsoncpp, libuv, rhash, make, clang, zlib"
MAGISK_MODULE_FORCE_CMAKE=true
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON -DBUILD_CursesDialog=ON"
