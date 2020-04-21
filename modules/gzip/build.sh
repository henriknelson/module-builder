MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/gzip/
MAGISK_MODULE_DESCRIPTION="Standard GNU file compression utilities"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=1.10
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/gzip/gzip-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=8425ccac99872d544d4310305f915f5ea81e04d0f437ef1a230dc9d1c819d7c0
MAGISK_MODULE_ESSENTIAL=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="ac_cv_path_GREP=grep"

magisk_step_pre_configure() {
	if [ $MAGISK_ARCH = i686 ]; then
		# Avoid text relocations
		export DEFS="NO_ASM"
	fi
	CFLAGS+=" -static"
	LDFLAGS+=" -static"
}
