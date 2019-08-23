MAGISK_MODULE_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
MAGISK_MODULE_LICENSE="Public Domain"
# Note: Updating this version requires bumping the tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=29
_SQLITE_PATCH=0
MAGISK_MODULE_SHA256=8e7c1e2950b5b04c5944a981cb31fffbf9d2ddda939d536838ebc854481afd5b
MAGISK_MODULE_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://www.sqlite.org/2019/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
MAGISK_MODULE_DEPENDS="zlib"
MAGISK_MODULE_BREAKS="libsqlite-dev"
MAGISK_MODULE_REPLACES="libsqlite-dev"
# ac_cv_func_strerror_r=no as strerror_r() with the
# GNU signature is only # available in android-23:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_func_strerror_r=no
--enable-readline
--datarootdir=$MAGISK_PREFIX/usr/share
"

magisk_step_pre_configure() {
	CPPFLAGS+=" -Werror -DSQLITE_ENABLE_DBSTAT_VTAB=1"
	LDFLAGS+=" --static -lm"
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/src/libsqlite
	cp $MAGISK_MODULE_SRCDIR/tea/generic/tclsqlite3.c $MAGISK_PREFIX/src/libsqlite/tclsqlite3.c
}
