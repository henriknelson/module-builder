MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/binutils
MAGISK_MODULE_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.35.1
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/binutils/binutils-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=a8dfaae8cbbbc260fc1737a326adca97b5d4f3c95a82f0af1f7455ed1da5e77b
MAGISK_MODULE_DEPENDS="libc++, zlib, libandroid-spawn, libandroid-glob"
MAGISK_MODULE_BREAKS="binutils-dev"
MAGISK_MODULE_REPLACES="binutils-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-gold --enable-plugins --disable-werror --with-system-zlib --enable-new-dtags --enable-static --disable-shared"
MAGISK_MODULE_EXTRA_MAKE_ARGS="tooldir=$MAGISK_PREFIX"
MAGISK_MODULE_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1 bin/ld.bfd"
MAGISK_MODULE_NO_STATICSPLIT=true
MAGISK_MODULE_HAS_DEBUG=false
# Debug build fails with:
# ~/termux-build/binutils/src/binutils/readelf.c:19060:81: error: in call to 'fread', size * count is too large for the given buffer
#     if (fread (ehdr32.e_type, sizeof (ehdr32) - EI_NIDENT, 1, filedata->handle) != 1)
#                                                                               ^
# ~/termux-build/_cache/19b-aarch64-24-v5/bin/../sysroot/usr/include/bits/fortify/stdio.h:107:9: note: from 'diagnose_if' attribute on 'fread':
#        __clang_error_if(__bos(buf) != __BIONIC_FORTIFY_UNKNOWN_SIZE && size * count > __bos(buf),
#        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~/termux-build/_cache/19b-aarch64-24-v5/bin/../sysroot/usr/include/sys/cdefs.h:163:52: note: expanded from macro '__clang_error_if'
# #define __clang_error_if(cond, msg) __attribute__((diagnose_if(cond, msg, "error")))
#                                                    ^           ~~~~

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

magisk_step_pre_configure() {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"

	if [ $MAGISK_ARCH_BITS = 32 ]; then
		export LIB_PATH="${MAGISK_PREFIX}/lib:/system/lib"
	else
		export LIB_PATH="${MAGISK_PREFIX}/lib:/system/lib64"
	fi
	#export CFLAGS+=" -static -O2"
	export LDFLAGS+=" --static"
	export LIBS+=" -landroid-glob -landroid-spawn"
	export CPPFLAGS+=" -I/$MAGISK_PREFIX/include"
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
