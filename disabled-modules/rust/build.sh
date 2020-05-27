MAGISK_MODULE_HOMEPAGE=https://www.rust-lang.org/
MAGISK_MODULE_DESCRIPTION="Systems programming language focused on safety, speed and concurrency"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Kevin Cotugno @kcotugno"
MAGISK_MODULE_VERSION=1.42.0
MAGISK_MODULE_SRCURL=https://static.rust-lang.org/dist/rustc-${MAGISK_MODULE_VERSION}-src.tar.xz
MAGISK_MODULE_SHA256=aa5b4c0f2bac33cc26a11523fce9b0f120d2eff510ed148ae7c586501481ed04
MAGISK_MODULE_DEPENDS="libc++, clang, openssl, lld, zlib"

magisk_step_configure() {
	magisk_setup_cmake
	magisk_setup_rust

	# it breaks building rust tools without doing this because it tries to find
	# ../lib from bin location:
	# this is about to get ugly but i have to make sure a rustc in a proper bin lib
	# configuration is used otherwise it fails a long time into the build...
	# like 30 to 40 + minutes ... so lets get it right

	# 1.36 needs 1.35 to build revert to using $MAGISK_MODULE_VERSION next time..
	rustup install 1.35.0
	export PATH=$HOME/.rustup/toolchains/1.35.0-x86_64-unknown-linux-gnu/bin:$PATH
	local RUSTC=$(which rustc)
	local CARGO=$(which cargo)

	sed "s%\\@MAGISK_PREFIX\\@%$MAGISK_PREFIX%g" \
		$MAGISK_MODULE_BUILDER_DIR/config.toml \
		| sed "s%\\@MAGISK_STANDALONE_TOOLCHAIN\\@%$MAGISK_STANDALONE_TOOLCHAIN%g" \
		| sed "s%\\@triple\\@%$CARGO_TARGET_NAME%g" \
		| sed "s%\\@RUSTC\\@%$RUSTC%g" \
		| sed "s%\\@CARGO\\@%$CARGO%g" \
		> config.toml

	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export LD_LIBRARY_PATH=$MAGISK_MODULE_BUILDDIR/build/x86_64-unknown-linux-gnu/stage2/lib
	export ${env_host}_OPENSSL_DIR=$MAGISK_PREFIX
	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR=/usr/lib/x86_64-linux-gnu
	export X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR=/usr/include
	export MODULE_CONFIG_ALLOW_CROSS=1
	# for backtrace-sys
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu="-O2"
	unset CC CXX CPP LD CFLAGS CXXFLAGS CPPFLAGS LDFLAGS MODULE_CONFIG AR RANLIB
}

mmagisk_step_make() {
return 0;
}

magisk_step_make_install() {
	$MAGISK_MODULE_SRCDIR/x.py install  \
		--host $CARGO_TARGET_NAME \
		--target $CARGO_TARGET_NAME \
		--target wasm32-unknown-unknown

	cd "$MAGISK_PREFIX/lib"
	ln -sf rustlib/$CARGO_TARGET_NAME/lib/*.so .
	ln -sf $MAGISK_PREFIX/bin/lld $MAGISK_PREFIX/bin/rust-lld
}
