MAGISK_MODULE_HOMEPAGE=https://nodejs.org/
MAGISK_MODULE_DESCRIPTION="Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
MAGISK_MODULE_LICENSE="MIT"
# Note: package build may fail on Github Actions CI due to out-of-memory
# condition. It should be built locally instead.
MAGISK_MODULE_VERSION=14.14.0
MAGISK_MODULE_SRCURL=https://nodejs.org/dist/v${MAGISK_MODULE_VERSION}/node-v${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=04e935f4bd6b1e91c4a491e18d4d7a797009c3760b950cdefb193c4c079df0e6
# Note that we do not use a shared libuv to avoid an issue with the Android
# linker, which does not use symbols of linked shared libraries when resolving
# symbols on dlopen(). See https://github.com/magisk/magisk-packages/issues/462.
MAGISK_MODULE_DEPENDS="libc++, openssl, c-ares, libicu, zlib"
MAGISK_MODULE_CONFLICTS="nodejs-lts, nodejs-current"
MAGISK_MODULE_BREAKS="nodejs-dev"
MAGISK_MODULE_REPLACES="nodejs-current, nodejs-dev"
MAGISK_MODULE_SUGGESTS="clang, make, pkg-config, python"
MAGISK_MODULE_RM_AFTER_INSTALL="lib/node_modules/npm/html lib/node_modules/npm/make.bat share/systemtap lib/dtrace"
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_HOSTBUILD=true
# Build fails on x86_64 with:
# g++ -rdynamic -m64 -pthread -m64 -fPIC  -o /home/builder/.magisk-build/nodejs/src/out/Release/mksnapshot ...
# /usr/bin/ld: /home/builder/.magisk-build/nodejs/src/out/Release/obj.host/v8_base_without_compiler/deps/v8/src/api/api.o: 
# in function `v8::TryHandleWebAssemblyTrapPosix(int, siginfo_t*, void*)':
# api.cc:(.text._ZN2v829TryHandleWebAssemblyTrapPosixEiP9siginfo_tPv+0x5):
# undefined reference to `v8::internal::trap_handler::TryHandleSignal(int, siginfo_t*, void*)'
# /usr/bin/ld: /home/builder/.magisk-build/nodejs/src/out/Release/obj.host/v8_base_without_compiler/deps/v8/src/trap-handler/handler-outside.o:
# in function `v8::internal::trap_handler::EnableTrapHandler(bool)':
# handler-outside.cc:(.text._ZN2v88internal12trap_handler17EnableTrapHandlerEb+0x25):
# undefined reference to `v8::internal::trap_handler::RegisterDefaultTrapHandler()'
# collect2: error: ld returned 1 exit status
MAGISK_MODULE_BLACKLISTED_ARCHES="x86_64"

magisk_step_post_get_source() {
	# Prevent caching of host build:
	rm -Rf $MAGISK_MODULE_HOSTBUILD_DIR
}

magisk_step_host_build() {
	local ICU_VERSION=67.1
	local ICU_TAR=icu4c-${ICU_VERSION//./_}-src.tgz
	local ICU_DOWNLOAD=https://github.com/unicode-org/icu/releases/download/release-${ICU_VERSION//./-}/$ICU_TAR
	magisk_download \
		$ICU_DOWNLOAD\
		$MAGISK_MODULE_CACHEDIR/$ICU_TAR \
		94a80cd6f251a53bd2a997f6f1b5ac6653fe791dfab66e1eb0227740fb86d5dc
	tar xf $MAGISK_MODULE_CACHEDIR/$ICU_TAR
	cd icu/source
	if [ "$MAGISK_ARCH_BITS" = 32 ]; then
		./configure --prefix $MAGISK_MODULE_HOSTBUILD_DIR/icu-installed \
			--disable-samples \
			--disable-tests \
			--build=i686-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32"
	else
		./configure --prefix $MAGISK_MODULE_HOSTBUILD_DIR/icu-installed \
			--disable-samples \
			--disable-tests
	fi
	make -j $MAGISK_MAKE_PROCESSES install
}

magisk_step_configure() {
	local DEST_CPU
	if [ $MAGISK_ARCH = "arm" ]; then
		DEST_CPU="arm"
	elif [ $MAGISK_ARCH = "i686" ]; then
		DEST_CPU="ia32"
	elif [ $MAGISK_ARCH = "aarch64" ]; then
		DEST_CPU="arm64"
	elif [ $MAGISK_ARCH = "x86_64" ]; then
		DEST_CPU="x64"
	else
		magisk_error_exit "Unsupported arch '$MAGISK_ARCH'"
	fi

	export GYP_DEFINES="host_os=linux"
	export CC_host=gcc
	export CXX_host=g++
	export LINK_host=g++

	# See note above MAGISK_MODULE_DEPENDS why we do not use a shared libuv.
	./configure \
		--prefix=$MAGISK_PREFIX \
		--dest-cpu=$DEST_CPU \
		--dest-os=android \
		--shared-cares \
		--shared-openssl \
		--shared-zlib \
		--with-intl=system-icu \
		--cross-compiling

	export LD_LIBRARY_PATH=$MAGISK_MODULE_HOSTBUILD_DIR/icu-installed/lib
	perl -p -i -e "s@LIBS := \\$\\(LIBS\\)@LIBS := -L$MAGISK_MODULE_HOSTBUILD_DIR/icu-installed/lib -lpthread -licui18n -licuuc -licudata@" \
		$MAGISK_MODULE_SRCDIR/out/tools/v8_gypfiles/mksnapshot.host.mk \
		$MAGISK_MODULE_SRCDIR/out/tools/v8_gypfiles/torque.host.mk \
		$MAGISK_MODULE_SRCDIR/out/tools/v8_gypfiles/bytecode_builtins_list_generator.host.mk \
		$MAGISK_MODULE_SRCDIR/out/tools/v8_gypfiles/v8_libbase.host.mk \
		$MAGISK_MODULE_SRCDIR/out/tools/v8_gypfiles/gen-regexp-special-case.host.mk
}
