MAGISK_MODULE_HOMEPAGE=https://strace.io/
MAGISK_MODULE_DESCRIPTION="Debugging utility to monitor system calls and signals received"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_MAINTAINER="@termux"
MAGISK_MODULE_VERSION=5.10
MAGISK_MODULE_SRCURL=https://github.com/strace/strace/releases/download/v$MAGISK_MODULE_VERSION/strace-$MAGISK_MODULE_VERSION.tar.xz
MAGISK_MODULE_SHA256=fe3982ea4cd9aeb3b4ba35f6279f0b577a37175d3282be24b9a5537b56b8f01c
#MAGISK_MODULE_DEPENDS="libdw"

# Without st_cv_m32_mpers=no the build fails if gawk is installed.
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
st_cv_m32_mpers=no
--enable-mpers=no
"

# This is a perl script.
MAGISK_MODULE_RM_AFTER_INSTALL="bin/strace-graph"

magisk_step_pre_configure() {
	#CFLAGS+=" -I $MAGISK_PREFIX/include/elfutils -O2 -static"
	CPPFLAGS+=" -Dfputs_unlocked=fputs"
	LDFLAGS+=" -static -pthread"
}
