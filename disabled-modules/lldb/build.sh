MAGISK_MODULE_HOMEPAGE=https://lldb.llvm.org
MAGISK_MODULE_DESCRIPTION="LLVM based debugger"
MAGISK_MODULE_LICENSE="NCSA"
MAGISK_MODULE_VERSION=9.0.1
MAGISK_MODULE_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-$MAGISK_MODULE_VERSION/lldb-$MAGISK_MODULE_VERSION.src.tar.xz
MAGISK_MODULE_SHA256=8a7b9fd795c31a3e3cba6ce1377a2ae5c67376d92888702ce27e26f0971beb09
MAGISK_MODULE_DEPENDS="libc++, libedit, libllvm, libxml2, ncurses-ui-libs"
MAGISK_MODULE_BUILD_DEPENDS="libllvm-static"
MAGISK_MODULE_BREAKS="lldb-dev, lldb-static"
MAGISK_MODULE_REPLACES="lldb-dev, lldb-static"
MAGISK_MODULE_HAS_DEBUG=false
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
-DLLDB_DISABLE_CURSES=0
-DLLDB_DISABLE_LIBEDIT=0
-DLLDB_DISABLE_PYTHON=1
-DLLVM_CONFIG=$MAGISK_PREFIX/bin/llvm-config
-DLLVM_ENABLE_TERMINFO=1
-DLLVM_LINK_LLVM_DYLIB=ON
-DLLVM_DIR=$MAGISK_PREFIX/lib/cmake/llvm
-DClang_DIR=$MAGISK_PREFIX/lib/cmake/clang
-DLLVM_NATIVE_BUILD=$MAGISK_PREFIX/bin
"
magisk_step_pre_configure() {
	cd $MAGISK_MODULE_TMPDIR
	magisk_download https://its-pointless.github.io/tblgen-llvm-lldb-9.0.1.tar.xz tblgen-llvm-lldb-9.0.1.tar.xz \
		9cfd0aa3d9988e66838d4390ea9b2f701d1d8c87c44e226e10b8afd42c004622
	tar xvf tblgen-llvm-lldb-9.0.1.tar.xz
	mv llvm-tblgen $MAGISK_PREFIX/bin
	PATH=$PATH:$MAGISK_MODULE_TMPDIR
	if [ $MAGISK_ARCH = "x86_64" ]; then
		export LD_LIBRARY_PATH=/lib/x86_64-linux-gnu/
	fi
	touch $MAGISK_PREFIX/bin/clang-import-test
}

magisk_step_post_make_install() {
	cp $MAGISK_MODULE_SRCDIR/docs/lldb.1 $MAGISK_PREFIX/share/man/man1
	rm -f  $MAGISK_PREFIX/bin/llvm-tblgen $MAGISK_PREFIX/bin/clang-import-test
}
