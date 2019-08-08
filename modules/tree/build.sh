MAGISK_MODULE_HOMEPAGE=http://mama.indstate.edu/users/ice/tree/
MAGISK_MODULE_DESCRIPTION="Recursive directory lister producing a depth indented listing of files"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_MAINTAINER="Gert Scholten @gscholt"
MAGISK_MODULE_VERSION=1.8.0
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SHA256=715d5d4b434321ce74706d0dd067505bb60c5ea83b5f0b3655dae40aa6f9b7c2
MAGISK_MODULE_SRCURL=http://mama.indstate.edu/users/ice/tree/src/tree-${MAGISK_MODULE_VERSION}.tgz
#MAGISK_MODULE_DEPENDS="libandroid-support"
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_make() {
	make \
		CC="$CC" \
		CFLAGS="$CFLAGS $CPPFLAGS -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64" \
		LDFLAGS="$LDFLAGS --static" \
		OBJS="file.o tree.o unix.o html.o xml.o json.o hash.o color.o strverscmp.o"
}

magisk_step_make_install() {
	make install \
		prefix="$MAGISK_PREFIX" \
		MANDIR="$MAGISK_PREFIX/share/man/man1"
}
