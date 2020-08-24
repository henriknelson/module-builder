MAGISK_MODULE_HOMEPAGE=https://www.nano-editor.org/
MAGISK_MODULE_DESCRIPTION="Small, free and friendly text editor"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=5.2
MAGISK_MODULE_SHA256=32c2da43e1ae9a5e43437d8c6e1ec0388af870c7762c479e5bffb5f292bda7e1
MAGISK_MODULE_SRCURL=https://nano-editor.org/dist/latest/nano-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_DEPENDS="ncurses,libmagic"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_header_pwd_h=no
--enable-utf8
--enable-libmagic
--with-wordbounds
--datarootdir=$MAGISK_PREFIX/usr/share
--sysconfdir=$MAGISK_PREFIX/usr/share
"
MAGISK_MODULE_CONFFILES="usr/share/nanorc"
MAGISK_MODULE_RM_AFTER_INSTALL="bin/rnano usr/share/man/man1/rnano.1 usr/share/nano/man-html"
MAGISK_MODULE_BUILD_IN_SRC=y

magisk_step_pre_configure() {
	#export PATH=/usr/local/musl/bin:$PATH
	#export CC=/usr/local/musl/bin/aarch64-linux-musl-gcc
	MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --host=aarch64-linux-android --target=aarch64-linux-android"
	LDFLAGS+=" -static -lz -lmagic"
	if [ "$MAGISK_DEBUG" == "true" ]; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives this error:
		# /home/builder/.magisk-build/_lib/16-aarch64-21-v3/bin/../sysroot/usr/include/bits/fortify/string.h:79:26: error: use of undeclared identifier '__USE_FORTIFY_LEVEL'
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}

magisk_step_post_make_install() {
	# Configure nano to use syntax highlighting:
	rm -Rf $MAGISK_MODULE_MASSAGEDIR/system/usr/share/doc
	NANORC=$MAGISK_PREFIX/usr/share/nanorc
	echo include \"$MAGISK_PREFIX/usr/share/nano/\*nanorc\" > $NANORC
}
