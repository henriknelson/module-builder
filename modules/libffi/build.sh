MAGISK_MODULE_HOMEPAGE=https://sourceware.org/libffi/
MAGISK_MODULE_DESCRIPTION="Library providing a portable, high level programming interface to various calling conventions"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=3.3
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SRCURL=ftp://sourceware.org/pub/libffi/libffi-3.3.tar.gz
MAGISK_MODULE_SHA256=72fba7922703ddfa7a028d513ac15a85c8d54c8d67f55fa5a4802885dc652056
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--disable-multi-os-directory
"
MAGISK_MODULE_RM_AFTER_INSTALL="lib/libffi-${MAGISK_MODULE_VERSION}/include"

magisk_step_pre_configure() {
	if [ $MAGISK_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}
