MAGISK_MODULE_HOMEPAGE=https://www.rarlab.com/
MAGISK_MODULE_DESCRIPTION="Tool for extracting files from .rar archives"
MAGISK_MODULE_LICENSE="non-free"
MAGISK_MODULE_LICENSE_FILE="license.txt"
MAGISK_MODULE_VERSION=5.9.2
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://www.rarlab.com/rar/unrarsrc-5.9.2.tar.gz
MAGISK_MODULE_SHA256=73d3baf18cf0a197976af2794a848893c35e7d42cee0ff364c89d2e476ebdaa6
MAGISK_MODULE_DEPENDS="libandroid-support, libc++"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure(){
	CFLAGS=" -static"
	LDFLAGS=" --static"
}
