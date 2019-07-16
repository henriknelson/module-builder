MAGISK_MODULE_HOMEPAGE=https://sourceware.org/libffi/
MAGISK_MODULE_DESCRIPTION="Library providing a portable, high level programming interface to various calling conventions"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=3.2.1
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SRCURL=ftp://sourceware.org/pub/libffi/libffi-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--disable-multi-os-directory"
MAGISK_MODULE_RM_AFTER_INSTALL="lib/libffi-${MAGISK_MODULE_VERSION}/include"

magisk_step_pre_configure() {
	CC=/usr/local/musl/bin/aarch64-linux-musl-gcc
	LDFLAGS+="$LDFLAGS --static"

	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}
