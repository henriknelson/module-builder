MAGISK_MODULE_HOMEPAGE=https://strace.io/
MAGISK_MODULE_DESCRIPTION="Debugging utility to monitor system calls and signals received"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=5.6
MAGISK_MODULE_SRCURL=https://github.com/strace/strace/releases/download/v$MAGISK_MODULE_VERSION/strace-$MAGISK_MODULE_VERSION.tar.xz
MAGISK_MODULE_SHA256=189968eeae06ed9e20166ec55a830943c84374676a457c9fe010edc7541f1b01
MAGISK_MODULE_RM_AFTER_INSTALL=bin/strace-graph # This is a perl script
# Without st_cv_m32_mpers=no the build fails if gawk is installed.
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
st_cv_m32_mpers=no
--enable-mpers=no
--without-libdw
"

magisk_step_pre_configure() {
	CPPFLAGS+=" -Dfputs_unlocked=fputs"
	LDFLAGS+=" -static"
}
