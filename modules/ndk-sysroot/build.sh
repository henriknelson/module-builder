MAGISK_MODULE_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
MAGISK_MODULE_DESCRIPTION="System header and library files from the Android NDK needed for compiling C programs"
MAGISK_MODULE_LICENSE="NCSA"
MAGISK_MODULE_VERSION=$MAGISK_NDK_VERSION
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SKIP_SRC_EXTRACT=true
# This package has taken over <pty.h> from the previous libutil-dev
# and iconv.h from libandroid-support-dev:
MAGISK_MODULE_CONFLICTS="libutil-dev, libgcc, libandroid-support-dev"
MAGISK_MODULE_REPLACES="libutil-dev, libgcc, libandroid-support-dev, ndk-stl"
MAGISK_MODULE_NO_STATICSPLIT=true

magisk_step_extract_into_massagedir() {
	mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/lib \
		$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/include

	cp -Rf $MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/include/* \
		$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/include

	patch -d $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/include/c++/v1  -p1 < $MAGISK_MODULE_BUILDER_DIR/math-header.diff

	cp $MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$MAGISK_HOST_PLATFORM/$MAGISK_MODULE_API_LEVEL/*.o \
		$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/lib

	local LIBATOMIC_PATH=$MAGISK_STANDALONE_TOOLCHAIN/$MAGISK_HOST_PLATFORM/lib
	if [ $MAGISK_ARCH_BITS = 64 ]; then LIBATOMIC_PATH+="64"; fi
	if [ $MAGISK_ARCH = "arm" ]; then LIBATOMIC_PATH+="/armv7-a"; fi
	LIBATOMIC_PATH+="/libatomic.a"
	cp $LIBATOMIC_PATH $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/lib/

	local LIBGCC_PATH=$MAGISK_STANDALONE_TOOLCHAIN/lib/gcc/$MAGISK_HOST_PLATFORM/4.9.x
	if [ $MAGISK_ARCH = "arm" ]; then LIBGCC_PATH+="/armv7-a"; fi
	cp $LIBGCC_PATH/* -r $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/lib/
	cp $MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$MAGISK_HOST_PLATFORM/$MAGISK_MODULE_API_LEVEL/libcompiler_rt-extras.a $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/lib/
	# librt and libpthread are built into libc on android, so setup them as symlinks
	# to libc for compatibility with programs that users try to build:
	local _SYSTEM_LIBDIR=/system/lib64
	if [ $MAGISK_ARCH_BITS = 32 ]; then _SYSTEM_LIBDIR=/system/lib; fi
	mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/lib
	cd $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/lib
	if [ $MAGISK_ARCH = "arm" ]; then
		rm thumb -rf
		cp $MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/lib/$MAGISK_HOST_PLATFORM/libunwind.a .
	fi
	ln -f -s $_SYSTEM_LIBDIR/libc.so librt.so
	ln -f -s $_SYSTEM_LIBDIR/libc.so libpthread.so
}
