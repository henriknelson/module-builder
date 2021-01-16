MAGISK_MODULE_HOMEPAGE=https://www.rarlab.com/
MAGISK_MODULE_DESCRIPTION="Tool for extracting files from .rar archives"
MAGISK_MODULE_LICENSE="non-free"
MAGISK_MODULE_LICENSE_FILE="license.txt"
MAGISK_MODULE_VERSION=1.47.16
MAGISK_MODULE_REVISION=9
MAGISK_MODULE_SRCURL=http://mirrors.kernel.org/gnu/help2man/help2man-1.47.15.tar.xz
MAGISK_MODULE_SHA256=c25a35b30eceb315361484b0ff1f81c924e8ee5c8881576f1ee762f001dbcd1c
MAGISK_MODULE_DEPENDS="libandroid-support, libc++"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure(){
	CFLAGS=" -static"
	LDFLAGS=" --static"
}
