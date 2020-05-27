MAGISK_MODULE_HOMEPAGE=https://ninja-build.org
MAGISK_MODULE_DESCRIPTION="A small build system with a focus on speed"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=1.10.0
MAGISK_MODULE_SRCURL=https://github.com/ninja-build/ninja/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=3810318b08489435f8efc19c05525e80a993af5a55baa0dfeae0465a9d45f99f
MAGISK_MODULE_DEPENDS="libc++, libandroid-spawn"

magisk_step_pre_configure() {
	CXXFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -landroid-spawn"
}

magisk_step_configure() {
	$MAGISK_MODULE_SRCDIR/configure.py
}

magisk_step_make() {
	#if $MAGISK_ON_DEVICE_BUILD; then
	#	$MAGISK_MODULE_SRCDIR/configure.py --bootstrap
	#else
		magisk_setup_ninja
		ninja -j $MAGISK_MAKE_PROCESSES
	#fi
}

magisk_step_make_install() {
	cp ninja $MAGISK_PREFIX/bin
}
