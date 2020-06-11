MAGISK_MODULE_HOMEPAGE=https://www.rarlab.com/
MAGISK_MODULE_DESCRIPTION="Tool for extracting files from .rar archives"
MAGISK_MODULE_LICENSE="non-free"
MAGISK_MODULE_LICENSE_FILE="license.txt"
MAGISK_MODULE_VERSION=5.9.3
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://www.rarlab.com/rar/unrarsrc-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=28c176c29da86d7efe3cb9a227255d8340f761ba95969195982ec87c8eb2dd69
MAGISK_MODULE_DEPENDS="libandroid-support, libc++"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure(){
	CFLAGS=" -static"
	LDFLAGS=" --static"
}
