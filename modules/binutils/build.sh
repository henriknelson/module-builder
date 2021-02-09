MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/binutils/
MAGISK_MODULE_DESCRIPTION="Collection of binary tools, the main ones being ld, the GNU linker, and as, the GNU assembler"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_MAINTAINER="@termux"
MAGISK_MODULE_VERSION=2.36.1
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/binutils/binutils-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=e81d9edf373f193af428a0f256674aea62a9d74dfe93f65192d4eae030b0f3b0
MAGISK_MODULE_DEPENDS="libc++, zlib"
MAGISK_MODULE_BREAKS="binutils-dev"
MAGISK_MODULE_REPLACES="binutils-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-gold --enable-plugins --disable-werror --with-system-zlib --enable-new-dtags --enable-static --disable-shared"
MAGISK_MODULE_EXTRA_MAKE_ARGS="tooldir=$MAGISK_PREFIX"
MAGISK_MODULE_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1 bin/ld.bfd"
MAGISK_MODULE_NO_STATICSPLIT=true

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

magisk_step_pre_configure() {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"

	if [ $MAGISK_ARCH_BITS = 32 ]; then
		export LIB_PATH="${MAGISK_PREFIX}/lib:/system/lib"
	else
		export LIB_PATH="${MAGISK_PREFIX}/lib:/system/lib64"
	fi
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
