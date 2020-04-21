MAGISK_MODULE_HOMEPAGE=https://www.pcre.org
MAGISK_MODULE_DESCRIPTION="Perl 5 compatible regular expression library"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=10.34
MAGISK_MODULE_SHA256=74c473ffaba9e13db6951fd146e0143fe9887852ce73406a03277af1d9b798ca
MAGISK_MODULE_SRCURL=https://ftp.pcre.org/pub/pcre/pcre2-10.34.tar.bz2
MAGISK_MODULE_INCLUDE_IN_DEVMODULE="bin/pcre2-config"
#MAGISK_MODULE_RM_AFTER_INSTALL="
#bin/pcre2grep
#bin/pcre2test
#share/man/man1/pcre2*.1
#lib/libpcre2-posix.so
#"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--disable-shared
--enable-jit
--enable-pcre2-16
--enable-pcre2-32
--enable-pcre2-8
"

magisk_step_configure() {
	LDFLAGS="$LDFLAGS --static" $MAGISK_MODULE_SRCDIR/configure \
	  --prefix=$MAGISK_PREFIX \
	  --host=aarch64-linux-gnu \
	  --enable-static \
	  --disable-shared \
	  $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS
}
