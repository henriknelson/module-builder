MAGISK_MODULE_HOMEPAGE=https://www.nano-editor.org/
MAGISK_MODULE_DESCRIPTION="Small, free and friendly text editor"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=1.0.39
MAGISK_MODULE_SHA256=09436c4e3d0659d930ad6b0821a9bcecb53be75dc9c43455646531ba6bd443a6
MAGISK_MODULE_SRCURL=https://github.com/qhuyduong/arm_adb/archive/v${MAGISK_MODULE_VERSION}-aarch64.tar.gz
MAGISK_MODULE_DEPENDS="zlib, openssl"
MAGISK_MODULE_BUILD_IN_SRC=y

mmagisk_step_patch_module(){
	return
}

magisk_step_pre_configure() {
	#echo $(env)
	export ANDROID_NDK=$NDK
	#magisk_setup_golang
	git clone https://salsa.debian.org/android-tools-team/android-platform-external-boringssl.git boringssl
	cd boringssl/
	rm -rf debian/out
	rm -rf src
	git clone https://boringssl.googlesource.com/boringssl src
	export GOOS=android
	python src/util/generate_build_files.py android
	cd src
	mkdir build
	cd build
	MAGISK_MODULE_SRCDIR=$(pwd)/.. magisk_step_configure_cmake
exit
	cmake -DANDROID_ABI=arm64-v8a \
      	-DCMAKE_TOOLCHAIN_FILE=${NDK}/build/cmake/android.toolchain.cmake \
	-DOPENSSL_NO_CXX \
	-DANDROID_NATIVE_API_LEVEL=24 \
      	-GNinja \
	..

	cmake --build ..

	exit
	#make CFLAGS=-fPIC CC=$MAGISK_HOST_PLATFORM-gcc 

	export CFLAGS=" -D_XOPEN_SOURCE=700 \
		-DBORINGSSL_ANDROID_SYSTEM \
		-DBORINGSSL_IMPLEMENTATION \
	 	-DBORINGSSL_STATIC_LIBRARY \
		-DOPENSSL_SMALL \
		-fvisibility=hidden \
	  	-Wa,--noexecstack"

	export CPPFLAGS=" -Isrc/include -Isrc/crypt"

	export DEB_HOST_ARCH=arm64

	mkdir --parents debian/out
        $CC $^-o debian/out/libcrypto.a $CFLAGS $CPPFLAGS $LDFLAGS
	ln -s libcrypto.a debian/out/libcrypto.a

	make  -f debian/libcrypto.mk
	exit
	make CXXFLAGS=-fPIC CXX=$MAGISK_HOST_PLATFORM-g++ DEB_HOST_ARCH=arm64 -f debian/libssl.mk
	cd ..
}

mmagisk_step_configure() {
	export CC="$MAGISK_HOST_PLATFORM-gcc"
	#autoreconf -i --force
	#./configure --host=$MAGISK_HOST_PLATFORM --includedir=$(pwd)/openssl-1.0.2l/tmp/openssl/include --libdir=$(pwd)/openssl-1.0.2l/tmp/openssl/lib
}

magisk_step_make() {
	#export CFLAGS=" -I$(pwd)/openssl-1.0.2l/tmp/openssl/include $CFLAGS"
	#export LDFLAGS=" -L$(pwd)/openssl-1.0.2l/tmp/openssl/lib $LDFLAGS"
	cmake --build build-arm64 --config Release
}


