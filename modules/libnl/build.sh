MAGISK_MODULE_HOMEPAGE=https://github.com/thom311/libnl
MAGISK_MODULE_DESCRIPTION="Collection of libraries providing APIs to netlink protocol based Linux kernel interfaces"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=3.5.0
MAGISK_MODULE_SRCURL=https://github.com/thom311/libnl/releases/download/libnl${MAGISK_MODULE_VERSION//./_}/libnl-$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=352133ec9545da76f77e70ccb48c9d7e5324d67f6474744647a7ed382b5e05fa
MAGISK_MODULE_BREAKS="libnl-dev"
MAGISK_MODULE_REPLACES="libnl-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--disable-pthreads --disable-cli"

magisk_step_pre_configure() {
	CFLAGS+=" -Dsockaddr_storage=__kernel_sockaddr_storage"
}
