magisk_step_configure_cmake() {
	magisk_setup_cmake

	local TOOLCHAIN_ARGS="-DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=$MAGISK_STANDALONE_TOOLCHAIN"
	local BUILD_TYPE=MinSizeRel
	test -n "$MAGISK_DEBUG" && BUILD_TYPE=Debug

	local CMAKE_PROC=$MAGISK_ARCH
	test $CMAKE_PROC == "arm" && CMAKE_PROC='armv7-a'
	local MAKE_PROGRAM_PATH
	if [ $MAGISK_CMAKE_BUILD = Ninja ]; then
		magisk_setup_ninja
		MAKE_PROGRAM_PATH=$(which ninja)
	else
		MAKE_PROGRAM_PATH=$(which make)
	fi
	CCMAGISK_HOST_PLATFORM="aarch64-linux-android"
	CFLAGS+=" --host=$CCMAGISK_HOST_PLATFORM --target=$CCMAGISK_HOST_PLATFORM -fno-addrsig"
	CXXFLAGS+=" --host=$CCMAGISK_HOST_PLATFORM --target=$CCMAGISK_HOST_PLATFORM -fno-addrsig"
	LDFLAGS+=" --host=$CCMAGISK_HOST_PLATFORM --target=$CCMAGISK_HOST_PLATFORM"

	# XXX: CMAKE_{AR,RANLIB} needed for at least jsoncpp build to not
	# pick up cross compiled binutils tool in $PREFIX/bin:
	cmake -G "$MAGISK_CMAKE_BUILD" "$MAGISK_MODULE_SRCDIR" \
		-DCMAKE_AR="$(which $AR)" \
		-DCMAKE_UNAME="$(which uname)" \
		-DCMAKE_RANLIB="$(which $RANLIB)" \
		-DCMAKE_BUILD_TYPE=$BUILD_TYPE \
		-DCMAKE_CROSSCOMPILING=True \
		-DCMAKE_C_FLAGS="$CFLAGS $CPPFLAGS" \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS $CPPFLAGS" \
		-DCMAKE_LINKER="$MAGISK_STANDALONE_TOOLCHAIN/bin/$LD $LDFLAGS" \
		-DCMAKE_FIND_ROOT_PATH=$MAGISK_PREFIX \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
		-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
		-DCMAKE_INSTALL_PREFIX=$MAGISK_PREFIX \
		-DCMAKE_MAKE_PROGRAM=$MAKE_PROGRAM_PATH \
		-DCMAKE_SYSTEM_PROCESSOR=$CMAKE_PROC \
		-DCMAKE_SYSTEM_NAME=Android \
		-DCMAKE_SYSTEM_VERSION=$MAGISK_MODULE_API_LEVEL \
		-DCMAKE_SKIP_INSTALL_RPATH=ON \
		-DCMAKE_USE_SYSTEM_LIBRARIES=True \
		-DDOXYGEN_EXECUTABLE= \
		-DBUILD_TESTING=OFF \
		$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS $TOOLCHAIN_ARGS
}
