MAGISK_MODULE_HOMEPAGE=https://www.kernel.org/doc/man-pages/
MAGISK_MODULE_DESCRIPTION="Man pages for linux kernel and C library interfaces"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=(5.06
		    2013)
MAGISK_MODULE_SHA256=(70b8a902a9daa0a596188c1925373199dbad590eb06d7c0e505c4b33e8bbfe50
		   19633a5c75ff7deab35b1d2c3d5b7748e7bd4ef4ab598b647bb7e7f60b90a808)
MAGISK_MODULE_SRCURL=(https://www.kernel.org/pub/linux/docs/man-pages/man-pages-${MAGISK_MODULE_VERSION}.tar.xz
		   https://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/man-pages-posix-${MAGISK_MODULE_VERSION[1]}-a.tar.xz)
MAGISK_MODULE_DEPENDS="man"
MAGISK_MODULE_EXTRA_MAKE_ARGS="prefix=$TERMUX_PREFIX"
MAGISK_MODULE_PLATFORM_INDEPENDENT=true
MAGISK_MODULE_BUILD_IN_SRC=true
# Problems with changing permissions of non-built files
MAGISK_MAKE_PROCESSSES=1



# man.7 and mdoc.7 is included with mandoc:
# getconf man page included with the getconf package:
# iconv-related manpages included with libiconv package:

magisk_step_pre_configure() {
	# Bundle posix man pages in same package:
	cd man-pages-posix-2013-a
	LDFLAGS=" --static" CFLAGS=" -static" make $MAGISK_MODULE_EXTRA_MAKE_ARGS install
}

mmagisk_step_post_massage() {
	cd $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX
	mkdir usr
	mv share usr/
}
