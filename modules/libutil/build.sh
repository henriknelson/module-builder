MAGISK_MODULE_HOMEPAGE=https://refspecs.linuxbase.org/LSB_2.1.0/LSB-generic/LSB-generic/libutil.html
MAGISK_MODULE_DESCRIPTION="Library with terminal functions"
MAGISK_MODULE_VERSION=0.3
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_make_install () {
	CPPFLAGS+=" -std=c11 -Wall -Werror"
	$CC $CPPFLAGS $CFLAGS -c -fPIC $MAGISK_MODULE_BUILDER_DIR/pty.c -o pty.o
	$CC -shared -fPIC $LDFLAGS -o $MAGISK_PREFIX/lib/libutil.so pty.o
}
