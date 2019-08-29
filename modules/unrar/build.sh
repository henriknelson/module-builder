MAGISK_MODULE_HOMEPAGE=https://www.rarlab.com/
MAGISK_MODULE_DESCRIPTION="Tool for extracting files from .rar archives"
MAGISK_MODULE_LICENSE="non-free"
MAGISK_MODULE_LICENSE_FILE="license.txt"
MAGISK_MODULE_VERSION=5.7.5
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://www.rarlab.com/rar/unrarsrc-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=e1c2fddaa87a88b1535bfc10ca484f3c5af4e5a55fbb933f8819e26203bbe2ee
MAGISK_MODULE_DEPENDS="libandroid-support, libc++"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure(){
	CFLAGS=" -static"
	LDFLAGS=" --static"
}
