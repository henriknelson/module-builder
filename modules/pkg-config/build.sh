MAGISK_MODULE_HOMEPAGE=https://www.freedesktop.org/wiki/Software/pkg-config/
MAGISK_MODULE_DESCRIPTION="Helper tool used when compiling applications and libraries"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=0.29.2
MAGISK_MODULE_SRCURL=https://pkgconfig.freedesktop.org/releases/pkg-config-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=6fc69c01688c9458a57eb9a1664c9aba372ccda420a02bf4429fe610e7e7d591
MAGISK_MODULE_DEPENDS="glib"
MAGISK_MODULE_RM_AFTER_INSTALL="bin/*-pkg-config"

magisk_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $MAGISK_PREFIX.
	#if $MAGISK_ON_DEVICE_BUILD; then
	#	termux_error_exit "Package '$MAGISK_MODULE_NAME' is not safe for on-device builds."
	#fi

	rm -Rf $MAGISK_PREFIX/bin/*pkg-config
}
