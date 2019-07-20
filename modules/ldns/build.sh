MAGISK_MODULE_HOMEPAGE=https://www.nlnetlabs.nl/projects/ldns/
MAGISK_MODULE_DESCRIPTION="Library for simplifying DNS programming and supporting recent and experimental RFCs"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_DEPENDS="openssl"
MAGISK_MODULE_VERSION=1.7.0
MAGISK_MODULE_REVISION=5
MAGISK_MODULE_SRCURL=https://www.nlnetlabs.nl/downloads/ldns/ldns-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=c19f5b1b4fb374cfe34f4845ea11b1e0551ddc67803bd6ddd5d2a20f0997a6cc
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--with-ssl=$MAGISK_PREFIX
--disable-gost
"
MAGISK_MODULE_INCLUDE_IN_DEVPACKAGE="bin/ldns-config share/man/man1/ldns-config.1"

magisk_step_post_make_install() {
	# The ldns build doesn't install its pkg-config:
	mkdir -p $MAGISK_PREFIX/lib/pkgconfig
	cp packaging/libldns.pc $MAGISK_PREFIX/lib/pkgconfig/libldns.pc
}
