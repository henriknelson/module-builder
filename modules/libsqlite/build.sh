MAGISK_MODULE_HOMEPAGE=https://www.sqlite.org
MAGISK_MODULE_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
MAGISK_MODULE_LICENSE="Public Domain"
# Note: Updating this version requires bumping the tcl package as well.
_SQLITE_MAJOR=3
_SQLITE_MINOR=33
_SQLITE_PATCH=0
MAGISK_MODULE_VERSION=${_SQLITE_MAJOR}.${_SQLITE_MINOR}.${_SQLITE_PATCH}
MAGISK_MODULE_SRCURL=https://www.sqlite.org/2020/sqlite-autoconf-${_SQLITE_MAJOR}${_SQLITE_MINOR}0${_SQLITE_PATCH}00.tar.gz
MAGISK_MODULE_SHA256=106a2c48c7f75a298a7557bcc0d5f4f454e5b43811cc738b7ca294d6956bbb15
MAGISK_MODULE_DEPENDS="zlib"
MAGISK_MODULE_BREAKS="libsqlite-dev"
MAGISK_MODULE_REPLACES="libsqlite-dev"
# ac_cv_func_strerror_r=no as strerror_r() with the
# GNU signature is only # available in android-23:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_func_strerror_r=no
--with-gnu-ld
--enable-readline
--with-static
--without-shared
--enable-static
--disable-shared
--enable-static-shell=yes
"

magisk_step_pre_configure() {
	export CC=/usr/local/musl/bin/aarch64-linux-musl-gcc
	CPPFLAGS+=" -Werror -DSQLITE_ENABLE_DBSTAT_VTAB=1"
	#export LDFLAGS="$LDFLAGS -lc -lm -ldl -static"
	export LIBS=" -lc -lm -ldl"
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/src/libsqlite
	cp $MAGISK_MODULE_SRCDIR/tea/generic/tclsqlite3.c $MAGISK_PREFIX/src/libsqlite/tclsqlite3.c
}
