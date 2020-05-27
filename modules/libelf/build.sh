MAGISK_MODULE_HOMEPAGE=https://sourceware.org/elfutils/
MAGISK_MODULE_DESCRIPTION="ELF object file access library"
MAGISK_MODULE_LICENSE="GPL-2.0"
# NOTE: We only build the libelf part of elfutils for now,
# as other parts are not clang compatible.
MAGISK_MODULE_VERSION=0.179
MAGISK_MODULE_SRCURL=ftp://sourceware.org/pub/elfutils/${MAGISK_MODULE_VERSION}/elfutils-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=25a545566cbacaa37ae6222e58f1c48ea4570f53ba991886e2f5ce96e22a23a2
# libandroid-support for langinfo.
MAGISK_MODULE_DEPENDS="libandroid-support, zlib"
MAGISK_MODULE_BUILD_DEPENDS="argp"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="ac_cv_c99=yes --disable-symbol-versioning --disable-debuginfod"
MAGISK_MODULE_CONFLICTS="elfutils, libelf-dev"
MAGISK_MODULE_REPLACES="elfutils, libelf-dev"

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --prefix=/system --disable-shared"
# --libdir=/system/lib --includedir=/system/include --disable-nls --enable-static --disable-shared host_alias=aarch64-linux-android"

magisk_step_pre_configure() {
	CFLAGS+=" -Wno-error=unused-value -Wno-error=format-nonliteral -Wno-error"

	# Exposes ACCESSPERMS in <sys/stat.h> which elfutils uses:
	CFLAGS+=" -D__USE_BSD"

	CFLAGS+=" -DFNM_EXTMATCH=0"

	#CFLAGS+=" -USHARED"

	#CFLAGS+=" -static"

	#LDFLAGS+=" -static"

	if [ "$MAGISK_ARCH" = "arm" ]; then
		CFLAGS="${CFLAGS/-Oz/-O1}"
	fi

	#export dso_LDFLAGS=" -static"

	#export DEPSHLIBS=" -landroid-support -lz"


	#export PKG_CONFIG_LIBDIR=$MAGISK_PREFIX/lib/pkgconfig

	cp $MAGISK_MODULE_BUILDER_DIR/error.h .
	cp $MAGISK_MODULE_BUILDER_DIR/stdio_ext.h .
	cp $MAGISK_MODULE_BUILDER_DIR/obstack.h .
	cp $MAGISK_MODULE_BUILDER_DIR/qsort_r.h .
	cp $MAGISK_MODULE_BUILDER_DIR/aligned_alloc.c libelf
	autoreconf -if
}

magisk_step_make() {
	make -j $MAGISK_MAKE_PROCESSES -C lib
	make -j $MAGISK_MAKE_PROCESSES -C libelf
}

magisk_step_make_install() {
	make -j $MAGISK_MAKE_PROCESSES -C libelf install
	rm -Rf $MAGISK_PREFIX/lib/libelf.so
	rm -Rf $MAGISK_PREFIX/lib/libelf.so.1
	rm -Rf $MAGISK_PREFIX/lib/libelf-0.179.so
}
