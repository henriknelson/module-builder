MAGISK_MODULE_HOMEPAGE=https://termux.com
MAGISK_MODULE_DESCRIPTION="Suggest installation of packages in interactive shell sessions"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=1.59
MAGISK_MODULE_SKIP_SRC_EXTRACT=true

magisk_step_make_install() {
	MAGISK_LIBEXEC_DIR=$MAGISK_PREFIX/libexec/magisk
	mkdir -p $MAGISK_LIBEXEC_DIR
	LDFLAGS+=" --static"
	$CC -Wall -Wextra -Werror -pedantic $CFLAGS $LDFLAGS -std=c11 $MAGISK_MODULE_BUILDER_DIR/command-not-found.c \
		-o $MAGISK_LIBEXEC_DIR/command-not-found
}
