MAGISK_MODULE_HOMEPAGE=https://www.rarlab.com/
MAGISK_MODULE_DESCRIPTION="Tool for extracting files from .rar archives"
MAGISK_MODULE_LICENSE="non-free"
MAGISK_MODULE_LICENSE_FILE="license.txt"
MAGISK_MODULE_VERSION=1.47.13
MAGISK_MODULE_REVISION=9
MAGISK_MODULE_SRCURL=http://mirrors.kernel.org/gnu/help2man/help2man-1.47.13.tar.xz
MAGISK_MODULE_SHA256=b7f8bbad1f2c405db747e3f5a4d5e1eddc63b360221c824bf79748f27b560523
MAGISK_MODULE_DEPENDS="libandroid-support, libc++"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure(){
	CFLAGS=" -static"
	LDFLAGS=" --static"
}
