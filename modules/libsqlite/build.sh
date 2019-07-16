MAGISK_MODULE_HOMEPAGE=https://www.sqlite.org
MAGISK_MODULE_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
MAGISK_MODULE_LICENSE="Public Domain"
# Note: Updating this version requires bumping the tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=28
_SQLITE_PATCH=0
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SHA256=d61b5286f062adfce5125eaf544d495300656908e61fca143517afcc0a89b7c3
MAGISK_MODULE_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
MAGISK_MODULE_SRCURL=https://www.sqlite.org/2019/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
MAGISK_MODULE_DEPENDS="zlib"
# ac_cv_func_strerror_r=no as strerror_r() with the
# GNU signature is only # available in android-23:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_func_strerror_r=no
--enable-readline
"
MAGISK_MODULE_INCLUDE_IN_DEVPACKAGE="src/libsqlite/tclsqlite3.c"

magisk_step_pre_configure() {
	CC=/usr/local/musl/bin/aarch64-linux-musl-gcc
	CPPFLAGS+=" -Werror -DSQLITE_ENABLE_DBSTAT_VTAB=1"
	LDFLAGS+=" -lm"
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/src/libsqlite
	cp $MAGISK_MODULE_SRCDIR/tea/generic/tclsqlite3.c $MAGISK_PREFIX/src/libsqlite/tclsqlite3.c
}
