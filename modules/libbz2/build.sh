MAGISK_MODULE_HOMEPAGE=http://www.bzip.org/
MAGISK_MODULE_DESCRIPTION="BZ2 format compression library"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.0.7
MAGISK_MODULE_SRCURL=https://fossies.org/linux/misc/bzip2-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=3a704a84a4b98fc88b0cfc5d3b6bab8edd658133fda4de09ec7512b2dfb49d81
MAGISK_MODULE_EXTRA_MAKE_ARGS="PREFIX=$MAGISK_PREFIX"
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_configure() {
	# bzip2 does not use configure. But place man pages at correct path:
	sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" $MAGISK_MODULE_SRCDIR/Makefile
}

magisk_step_make() {
	# bzip2 uses a separate makefile for the shared library
	CC=/usr/local/musl/bin/aarch64-linux-musl-gcc
	LDFLAGS+=" --static"
	make -f Makefile-libbz2_so
}

magisk_step_make_install() {
	# The shared library makefile contains no install makefile, so issue a normal install to get scripts
	make $MAGISK_MODULE_EXTRA_MAKE_ARGS install

	# Clean out statically linked binaries and libs and replace them with shared ones:
	rm -Rf $MAGISK_PREFIX/lib/libbz2*
	rm -Rf $MAGISK_PREFIX/bin/{bzcat,bunzip2}
	cp bzip2-shared $MAGISK_PREFIX/bin/bzip2
	cp libbz2.so.${MAGISK_MODULE_VERSION} $MAGISK_PREFIX/lib
	(cd $MAGISK_PREFIX/lib && ln -s libbz2.so.${MAGISK_MODULE_VERSION} libbz2.so.1.0)
	(cd $MAGISK_PREFIX/lib && ln -s libbz2.so.${MAGISK_MODULE_VERSION} libbz2.so)
	(cd $MAGISK_PREFIX/bin && ln -s bzip2 bzcat)
	(cd $MAGISK_PREFIX/bin && ln -s bzip2 bunzip2)
	# bzgrep should be enough so remove bz{e,f}grep
	rm $MAGISK_PREFIX/bin/bz{e,f}grep $MAGISK_PREFIX/share/man/man1/bz{e,f}grep.1
}
