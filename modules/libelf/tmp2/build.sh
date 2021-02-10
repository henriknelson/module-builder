MAGISK_MODULE_HOMEPAGE=https://sourceware.org/elfutils/
MAGISK_MODULE_DESCRIPTION="ELF object file access library"
MAGISK_MODULE_LICENSE="GPL-2.0"
# NOTE: We only build the libelf part of elfutils for now,
# as other parts are not clang compatible.
MAGISK_MODULE_VERSION=0.182
MAGISK_MODULE_SRCURL=ftp://sourceware.org/pub/elfutils/${MAGISK_MODULE_VERSION}/elfutils-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=ecc406914edf335f0b7fc084ebe6c460c4d6d5175bfdd6688c1c78d9146b8858
# libandroid-support for langinfo.
MAGISK_MODULE_DEPENDS="libandroid-support, zlib"
MAGISK_MODULE_BUILD_DEPENDS="argp"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="ac_cv_c99=yes --disable-symbol-versioning --disable-debuginfod"
MAGISK_MODULE_CONFLICTS="elfutils, libelf-dev"
MAGISK_MODULE_REPLACES="elfutils, libelf-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --prefix=/system --disable-shared"

magisk_step_pre_configure() {
	CFLAGS+=" -Wno-error=unused-value -Wno-error=format-nonliteral -Wno-error"

	# Exposes ACCESSPERMS in <sys/stat.h> which elfutils uses:
	CFLAGS+=" -D__USE_BSD"

	CFLAGS+=" -DFNM_EXTMATCH=0"

	if [ "$MAGISK_ARCH" = "arm" ]; then
		CFLAGS="${CFLAGS/-Oz/-O1}"
	fi

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
	make -j $MAGISK_MAKE_PROCESSES -C libdwfl
	make -j $MAGISK_MAKE_PROCESSES -C libebl
	make -j $MAGISK_MAKE_PROCESSES -C backends
	make -j $MAGISK_MAKE_PROCESSES -C libcpu
	make -j $MAGISK_MAKE_PROCESSES -C libdwelf
	make -j $MAGISK_MAKE_PROCESSES -C libdw
}

magisk_step_make_install() {
	make -j $MAGISK_MAKE_PROCESSES -C libelf install
	make -j $MAGISK_MAKE_PROCESSES -C libdwfl install
	make -j $MAGISK_MAKE_PROCESSES -C libdw install
	make -j $MAGISK_MAKE_PROCESSES -C libasm install
	make install-pkgincludeHEADERS
	make -C config install
}
