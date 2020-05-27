MAGISK_MODULE_HOMEPAGE=https://clang.llvm.org/
MAGISK_MODULE_DESCRIPTION="Modular compiler and toolchain technologies library"
MAGISK_MODULE_LICENSE="NCSA"
MAGISK_MODULE_VERSION=9.0.1
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SHA256=(00a1ee1f389f81e9979f3a640a01c431b3021de0d42278f6508391a2f0b81c9a
		   5778512b2e065c204010f88777d44b95250671103e434f9dc7363ab2e3804253		   
		   86262bad3e2fd784ba8c5e2158d7aa36f12b85f2515e95bc81d65d75bb9b0c82
		   5c94060f846f965698574d9ce22975c0e9f04c9b14088c3af5f03870af75cace)
MAGISK_MODULE_SRCURL=(https://github.com/llvm/llvm-project/releases/download/llvmorg-$MAGISK_MODULE_VERSION/llvm-$MAGISK_MODULE_VERSION.src.tar.xz
                   https://github.com/llvm/llvm-project/releases/download/llvmorg-$MAGISK_MODULE_VERSION/clang-$MAGISK_MODULE_VERSION.src.tar.xz
                   https://github.com/llvm/llvm-project/releases/download/llvmorg-$MAGISK_MODULE_VERSION/lld-$MAGISK_MODULE_VERSION.src.tar.xz
                   https://github.com/llvm/llvm-project/releases/download/llvmorg-$MAGISK_MODULE_VERSION/openmp-$MAGISK_MODULE_VERSION.src.tar.xz)
MAGISK_MODULE_HOSTBUILD=true
MAGISK_MODULE_RM_AFTER_INSTALL="
bin/clang-check
bin/clang-import-test
bin/clang-offload-bundler
bin/git-clang-format
bin/macho-dump
lib/libgomp.a
lib/libiomp5.a
"
MAGISK_MODULE_DEPENDS="binutils, libc++, ncurses, ndk-sysroot, libffi, zlib"
# Replace gcc since gcc is deprecated by google on android and is not maintained upstream.
# Conflict with clang versions earlier than 3.9.1-3 since they bundled llvm.
MAGISK_MODULE_CONFLICTS="gcc, clang (<< 3.9.1-3)"
MAGISK_MODULE_BREAKS="libclang, libclang-dev, libllvm-dev"
MAGISK_MODULE_REPLACES="gcc, libclang, libclang-dev, libllvm-dev"
# See http://llvm.org/docs/CMake.html:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
-DPYTHON_EXECUTABLE=$(which python3)
-DLLVM_BUILD_STATIC=ON
-DLLVM_ENABLE_PIC=ON
-DLLVM_ENABLE_LIBEDIT=OFF
-DLLVM_BUILD_TESTS=OFF
-DLLVM_INCLUDE_TESTS=OFF
-DCLANG_DEFAULT_CXX_STDLIB=libc++
-DCLANG_INCLUDE_TESTS=OFF
-DCLANG_TOOL_C_INDEX_TEST_BUILD=OFF
-DDEFAULT_SYSROOT=$(dirname $MAGISK_PREFIX)
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_TABLEGEN=$MAGISK_MODULE_HOSTBUILD_DIR/bin/llvm-tblgen
-DCLANG_TABLEGEN=$MAGISK_MODULE_HOSTBUILD_DIR/bin/clang-tblgen
-DLIBOMP_ENABLE_SHARED=FALSE
-DOPENMP_ENABLE_LIBOMPTARGET=OFF
-DLLVM_BINUTILS_INCDIR=$MAGISK_PREFIX/include
-DLLVM_ENABLE_SPHINX=ON
-DSPHINX_OUTPUT_MAN=ON
-DLLVM_TARGETS_TO_BUILD=all
-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=RISCV
-DPERL_EXECUTABLE=$(which perl)
-DLLVM_ENABLE_FFI=ON
-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR
"
MAGISK_MODULE_FORCE_CMAKE=true
MAGISK_MODULE_HAS_DEBUG=false
# Debug build succeeds but make install with:
# cp: cannot stat '../src/projects/openmp/runtime/exports/common.min.50.ompt.optional/include/omp.h': No such file or directory
# common.min.50.ompt.optional should be common.deb.50.ompt.optional when doing debug build

magisk_step_post_extract_module() {
	#if [ "$MAGISK_MODULE_QUICK_REBUILD" = "false" ]; then
		mv clang-${MAGISK_MODULE_VERSION}.src tools/clang
		mv lld-${MAGISK_MODULE_VERSION}.src tools/lld
		mv openmp-${MAGISK_MODULE_VERSION}.src projects/openmp
	#fi
}

magisk_step_host_build() {
	magisk_setup_cmake
	cmake -G "Unix Makefiles" $MAGISK_MODULE_SRCDIR \
		-DLLVM_BUILD_TESTS=OFF \
		-DLLVM_INCLUDE_TESTS=OFF
	make -j $MAGISK_MAKE_PROCESSES clang-tblgen llvm-tblgen
}

magisk_step_pre_configure() {
	#if [ "$MAGISK_MODULE_QUICK_REBUILD" = "false" ]; then
		mkdir projects/openmp/runtime/src/android
		cp $MAGISK_MODULE_BUILDER_DIR/nl_types.h projects/openmp/runtime/src/android
		cp $MAGISK_MODULE_BUILDER_DIR/nltypes_stubs.cpp projects/openmp/runtime/src/android
	#fi

	cd $MAGISK_MODULE_BUILDDIR
	export LLVM_DEFAULT_TARGET_TRIPLE=$MAGISK_HOST_PLATFORM
	export LLVM_TARGET_ARCH
	if [ $MAGISK_ARCH = "arm" ]; then
		LLVM_TARGET_ARCH=ARM
	elif [ $MAGISK_ARCH = "aarch64" ]; then
		LLVM_TARGET_ARCH=AArch64
	elif [ $MAGISK_ARCH = "i686" ]; then
		LLVM_TARGET_ARCH=X86
	elif [ $MAGISK_ARCH = "x86_64" ]; then
		LLVM_TARGET_ARCH=X86
	else
		magisk_error_exit "Invalid arch: $MAGISK_ARCH"
	fi
	# see CMakeLists.txt and tools/clang/CMakeLists.txt
	MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" -DLLVM_DEFAULT_TARGET_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"
	MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH -DLLVM_TARGETS_TO_BUILD=all"
	MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"
}
magisk_step_post_make_install() {
	if [ $MAGISK_ARCH = "arm" ]; then
		cp ../src/projects/openmp/runtime/exports/common.min/include/omp.h $MAGISK_PREFIX/include
	else
		cp ../src/projects/openmp/runtime/exports/common.min.ompt.optional/include/omp.h $MAGISK_PREFIX/include
	fi	
	if [ "$MAGISK_CMAKE_BUILD" = Ninja ]; then
		ninja docs-llvm-man
	else
		make docs-llvm-man
	fi

	cp docs/man/* $MAGISK_PREFIX/share/man/man1
	cd $MAGISK_PREFIX/bin

	for tool in clang clang++ cc c++ cpp gcc g++ ${MAGISK_HOST_PLATFORM}-{clang,clang++,gcc,g++,cpp}; do
		ln -f -s clang-${MAGISK_MODULE_VERSION:0:1} $tool
	done
}

magisk_step_post_massage() {
	sed $MAGISK_MODULE_BUILDER_DIR/llvm-config.in \
		-e "s|@MAGISK_MODULE_VERSION@|$MAGISK_MODULE_VERSION|g" \
		-e "s|@MAGISK_PREFIX@|$MAGISK_PREFIX|g" \
		-e "s|@MAGISK_MODULE_SRCDIR@|$MAGISK_MODULE_SRCDIR|g" \
		-e "s|@LLVM_TARGET_ARCH@|$LLVM_TARGET_ARCH|g" \
		-e "s|@LLVM_DEFAULT_TARGET_TRIPLE@|$LLVM_DEFAULT_TARGET_TRIPLE|g" \
		-e "s|@MAGISK_ARCH@|$MAGISK_ARCH|g" > $MAGISK_PREFIX/bin/llvm-config
	chmod 755 $MAGISK_PREFIX/bin/llvm-config
	cp $MAGISK_MODULE_HOSTBUILD_DIR/bin/llvm-tblgen $MAGISK_PREFIX/bin
	cp $MAGISK_MODULE_HOSTBUILD_DIR/bin/clang-tblgen $MAGISK_PREFIX/bin
}
