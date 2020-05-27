MAGISK_MODULE_HOMEPAGE=https://sourceware.org/libffi/
MAGISK_MODULE_DESCRIPTION="Library providing a portable, high level programming interface to various calling conventions"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=3.3
MAGISK_MODULE_SRCURL=ftp://sourceware.org/pub/libffi/libffi-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=72fba7922703ddfa7a028d513ac15a85c8d54c8d67f55fa5a4802885dc652056
MAGISK_MODULE_BREAKS="libffi-dev"
MAGISK_MODULE_REPLACES="libffi-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+="--disable-multi-os-directory --enable-shared"
MAGISK_MODULE_RM_AFTER_INSTALL="lib/libffi-${MAGISK_MODULE_VERSION}/include"

magisk_step_pre_configure() {
	if [ $MAGISK_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}

magisk_step_post_configure() {
	# work around since mmap can't be written and marked executable in android anymore from userspace
	echo "#define FFI_MMAP_EXEC_WRIT 1" >> fficonfig.h
}
