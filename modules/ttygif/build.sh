MAGISK_MODULE_HOMEPAGE=https://github.com/icholy/ttygif
MAGISK_MODULE_DESCRIPTION=""
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.4.0
MAGISK_MODULE_SRCURL=https://github.com/icholy/ttygif/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=6ca3dc5dcade2bdcf8000068ae991eac518204960c157634d92f87248c3cee2a
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	#rm -f Makefile release.Makefile
	#export CC_x86_64_unknown_linux_gnu=gcc
	#export CFLAGS_x86_64_unknown_linux_gnu="-O2"
	#export LDFLAGS="$LDFLAGS -lc -static"
	export target_host=aarch64-linux-android;
      	export AR=$target_host-ar;
	export AS=$target_host-as;
	export LD=$target_host-ld;
	export RANLIB=$target_host-ranlib;
	export STRIP=$target_host-strip;
	export CC=$target_host-clang;
	export GCC=$target_host-gcc;
	export CXX=$target_host-clang++;
	export GXX=$target_host-g++;
	export CFLAGS=' -static -O3';
	export LDFLAGS=' -static';
}

magisk_step_make() {
	GCC=$CC make
}
