MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/binutils/
MAGISK_MODULE_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.34
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SHA256=53537d334820be13eeb8acb326d01c7c81418772d626715c7ae927a7d401cab3
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/binutils/binutils-2.34.tar.gz
MAGISK_MODULE_DEPENDS="zlib"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-gold --enable-plugins --disable-werror --with-system-zlib --enable-new-dtags"
MAGISK_MODULE_EXTRA_MAKE_ARGS="tooldir=$MAGISK_PREFIX"
MAGISK_MODULE_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1 bin/ld.bfd"
MAGISK_MODULE_KEEP_STATIC_LIBRARIES=true
MAGISK_MODULE_BUILD_IN_SRC=true

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

magisk_step_pre_configure() {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"
	export LDFLAGs="$LDFLAGS --static"
	export PREF=aarch64-linux-android
	#/usr/local/musl/aarch64-linux-musl
	if [ $MAGISK_ARCH_BITS = 32 ]; then
		export LIB_PATH="${PREF}/lib:/system/lib"
	else
		export LIB_PATH="${PREF}/lib:/system/lib64"
	fi
}

mmagisk_step_configure() {
	export PATH=/usr/local/musl/bin:$PATH
	PRE=/usr/local/musl/bin/aarch64-linux-musl
	CC=$PRE-gcc CXX=$PRE-c++ LD=$PRE-ld AR=$PRE-ar AS=$PRE-as LIB_PATH="/usr/local/musl/aarch64-linux-musl/lib" ./configure --host aarch64-linux-musl -with-lib-path=/usr/local/musl/aarch64-linux-musl/lib --disable-nls --disable-werror --disable-gdb --disable-libdecnumber --disable-readline --disable-sim --disable-shared
}

mmagisk_step_make() {
	export PATH=/usr/local/musl/bin:$PATH
	PRE=/usr/local/musl/bin/aarch64-linux-musl
	make CC=$PRE-gcc CXX=$PRE-c++ LD=$PRE-ld AR=$PRE-ar AS=$PRE-as LIB_PATH="/usr/local/musl/lib" CFLAGS+="-I/usr/local/musl/aarch64-linux-musl/include -static" LDFLAGS+="-L/usr/local/musl/aarch64-linux-musl/lib  --static"
}

magisk_step_post_make_install() {
	cp $MAGISK_MODULE_BUILDER_DIR/ldd $MAGISK_PREFIX/bin/ldd
	cd $MAGISK_PREFIX/bin
	# Setup symlinks as these are used when building, so used by
	# system setup in e.g. python, perl and libtool:
	for b in ar ld nm objdump ranlib readelf strip; do
		ln -s -f $b $MAGISK_HOST_PLATFORM-$b
	done
	ln -sf ld.gold gold
}
