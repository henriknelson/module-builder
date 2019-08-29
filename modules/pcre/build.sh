MAGISK_MODULE_HOMEPAGE=https://www.pcre.org
MAGISK_MODULE_DESCRIPTION="Library implementing regular expression pattern matching using the same syntax and semantics as Perl 5"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=8.43
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SRCURL=https://ftp.pcre.org/pub/pcre/pcre-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=91e762520003013834ac1adb4a938d53b22a216341c061b0cf05603b290faf6b
MAGISK_MODULE_BREAKS="pcre-dev"
MAGISK_MODULE_REPLACES="pcre-dev"
MAGISK_MODULE_RM_AFTER_INSTALL="bin/pcregrep bin/pcretest share/man/man1/pcre*.1"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-cpp --enable-jit --enable-utf8 --enable-unicode-properties --enable-static"

magisk_step_pre_configure() {
	LIBS=" -ldl"
	LDFLAGS=" --static"
	CFLAGS=" -static"
}
