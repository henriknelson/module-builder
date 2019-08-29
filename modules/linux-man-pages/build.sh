MAGISK_MODULE_HOMEPAGE=https://www.kernel.org/doc/man-pages/
MAGISK_MODULE_DESCRIPTION="Man pages for linux kernel and C library interfaces"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=(5.01
		    2013)
MAGISK_MODULE_SHA256=(7dfce1334e22e2565cf219a83c5cdfa1fc5e877d54ee15a0d1f5f1de5143b627
		   19633a5c75ff7deab35b1d2c3d5b7748e7bd4ef4ab598b647bb7e7f60b90a808)
MAGISK_MODULE_SRCURL=(https://www.kernel.org/pub/linux/docs/man-pages/man-pages-${MAGISK_MODULE_VERSION}.tar.xz
		   https://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/man-pages-posix-${MAGISK_MODULE_VERSION[1]}-a.tar.xz)
MAGISK_MODULE_DEPENDS="man"
MAGISK_MODULE_EXTRA_MAKE_ARGS="prefix=$MAGISK_PREFIX/usr"
MAGISK_MODULE_PLATFORM_INDEPENDENT=true
MAGISK_MODULE_BUILD_IN_SRC=true
# Problems with changing permissions of non-built files
MAGISK_MAKE_PROCESSSES=1

# man.7 and mdoc.7 is included with mandoc:
# getconf man page included with the getconf package:
# iconv-related manpages included with libiconv package:
MAGISK_MODULE_RM_AFTER_INSTALL="
usr/share/man/man1
usr/share/man/man3/iconv.3
usr/share/man/man3/iconv_close.3
usr/share/man/man3/iconv_open.3
usr/share/man/man8
usr/share/man/man7/man.7
usr/share/man/man7/mdoc.7
usr/share/man/man1p/getconf.1p"

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

