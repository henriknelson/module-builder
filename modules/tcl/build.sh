MAGISK_MODULE_HOMEPAGE=https://www.tcl.tk/
MAGISK_MODULE_DESCRIPTION="Powerful but easy to learn dynamic programming language"
MAGISK_MODULE_LICENSE="custom"
MAGISK_MODULE_LICENSE_FILE="license.terms"
MAGISK_MODULE_VERSION=8.6.10
MAGISK_MODULE_SRCURL=https://downloads.sourceforge.net/project/tcl/Tcl/${MAGISK_MODULE_VERSION}/tcl${MAGISK_MODULE_VERSION}-src.tar.gz
MAGISK_MODULE_SHA256=5196dbf6638e3df8d5c87b5815c8c2b758496eb6f0e41446596c9a4e638d87ed
MAGISK_MODULE_DEPENDS="libsqlite, zlib"
MAGISK_MODULE_BREAKS="tcl-dev, tcl-static"
MAGISK_MODULE_REPLACES="tcl-dev, tcl-static"
MAGISK_MODULE_NO_STATICSPLIT=true
MAGISK_MODULE_REVISION=1

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_func_memcmp_working=yes
ac_cv_func_memcmp=yes
ac_cv_func_strtod=yes
ac_cv_func_strtoul=yes
tcl_cv_strstr_unbroken=ok
tcl_cv_strtod_buggy=ok
tcl_cv_strtod_unbroken=ok
tcl_cv_strtoul_unbroken=ok
--disable-rpath
--enable-man-symlinks
--mandir=$MAGISK_PREFIX/usr/share/man
"

magisk_step_pre_configure() {
	MAGISK_MODULE_SRCDIR=$MAGISK_MODULE_SRCDIR/unix
	CFLAGS+=" -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD"
}

mmagisk_step_configure() {
	$MAGISK_MODULE_SRCDIR/configure $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS \
	--host=aarch64-linux-android;
}

magisk_step_post_make_install() {
	# expect needs private headers
	make install-private-headers
	local _MAJOR_VERSION=${MAGISK_MODULE_VERSION:0:3}
	cd $MAGISK_PREFIX/bin
	ln -f -s tclsh$_MAJOR_VERSION tclsh

	# Hack to use system libsqlite (https://www.sqlite.org/howtocompile.html#tcl)
	# since --with-system-sqlite fails to build:
	local NEW_LIBDIR=$MAGISK_PREFIX/lib/tcl$_MAJOR_VERSION/sqlite
	mkdir -p $NEW_LIBDIR
	$CC $CFLAGS $CPPFLAGS $LDFLAGS \
		-DUSE_SYSTEM_SQLITE=1 \
		-o $NEW_LIBDIR/libtclsqlite3.so \
		-shared \
		$MAGISK_PREFIX/src/libsqlite/tclsqlite3.c \
		-ltcl$_MAJOR_VERSION -lsqlite3
	local LIBSQLITE_VERSION=$($PKG_CONFIG --modversion sqlite3)
	echo "package ifneeded sqlite3 $LIBSQLITE_VERSION [list load [file join \$dir libtclsqlite3.so] Sqlite3]" > \
		$NEW_LIBDIR/pkgIndex.tcl

	# Needed to install $MAGISK_MODULE_LICENSE_FILE.
	MAGISK_MODULE_SRCDIR=$(dirname "$MAGISK_MODULE_SRCDIR")

	#avoid conflict with perl
	mv $MAGISK_PREFIX/usr/share/man/man3/Thread.3 $MAGISK_PREFIX/usr/share/man/man3/Tcl_Thread.3
}
