MAGISK_MODULE_HOMEPAGE=http://michael.dipperstein.com/crypt/
MAGISK_MODULE_DESCRIPTION="A crypt(3) implementation"
MAGISK_MODULE_LICENSE="BSD 2-Clause"
MAGISK_MODULE_VERSION=0.2
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_DEPENDS="openssl"

#magisk_step_pre_configure() {
#	CC=/usr/local/musl/bin/aarch64-linux-musl-gcc
#	LDFLAGS+="$LDFLAGS --static"
#}

magisk_step_make_install() {
	$CC $CFLAGS $CPPFLAGS $LDFLAGS -Wall -Wextra -fPIC -shared $MAGISK_MODULE_BUILDER_DIR/crypt3.c -lcrypto -o $MAGISK_PREFIX/lib/libcrypt.so
	mkdir -p $MAGISK_PREFIX/include/
	cp $MAGISK_MODULE_BUILDER_DIR/crypt.h $MAGISK_PREFIX/include
}
