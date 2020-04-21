MAGISK_MODULE_HOMEPAGE=https://www.pcre.org
MAGISK_MODULE_DESCRIPTION="Library implementing regular expression pattern matching using the same syntax and semantics as Perl 5"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=8.44
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SRCURL=https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.bz2
MAGISK_MODULE_SHA256=19108658b23b3ec5058edc9f66ac545ea19f9537234be1ec62b714c84399366d
MAGISK_MODULE_BREAKS="pcre-dev"
MAGISK_MODULE_REPLACES="pcre-dev"
MAGISK_MODULE_RM_AFTER_INSTALL="bin/pcregrep bin/pcretest share/man/man1/pcre*.1"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-cpp --enable-jit --enable-utf8 --enable-unicode-properties --enable-static"

magisk_step_pre_configure() {
	LIBS=" -ldl"
	LDFLAGS=" --static"
	CFLAGS=" -static"
}
