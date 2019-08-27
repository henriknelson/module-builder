MAGISK_MODULE_HOMEPAGE=https://github.com/royhills/arp-scan
MAGISK_MODULE_DESCRIPTION="arp-scan is a command-line tool for system discovery and fingerprinting. It constructs and sends ARP requests to the specified IP addresses, and displays any responses that are received."
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=1.9.5
MAGISK_MODULE_SRCURL=https://github.com/royhills/arp-scan/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=aa9498af84158a315b7e0ea6c2cddfa746660ca3987cbe7e32c0c90f5382d9d2
MAGISK_MODULE_DEPENDS="libpcap"
MAGISK_MODULE_BUILD_DEPENDS="libpcap-dev"

if [[ ${MAGISK_ARCH_BITS} == 32 ]]; then
    # Retrieved from compilation on device:
    MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+="pgac_cv_snprintf_long_long_int_format=%lld"
fi

magisk_step_pre_configure () {
	cp ${MAGISK_MODULE_BUILDER_DIR}/hsearch/* ${MAGISK_MODULE_SRCDIR}/
	aclocal
    	autoheader
	automake --add-missing
	autoconf
}
