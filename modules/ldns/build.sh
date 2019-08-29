MAGISK_MODULE_HOMEPAGE=https://www.nlnetlabs.nl/projects/ldns/
MAGISK_MODULE_DESCRIPTION="Library for simplifying DNS programming and supporting recent and experimental RFCs"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=1.7.1
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://www.nlnetlabs.nl/downloads/ldns/ldns-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=8ac84c16bdca60e710eea75782356f3ac3b55680d40e1530d7cea474ac208229
MAGISK_MODULE_DEPENDS="openssl"
MAGISK_MODULE_BREAKS="ldns-dev"
MAGISK_MODULE_REPLACES="ldns-dev"
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--with-ssl=$MAGISK_PREFIX
--disable-gost
"

magisk_step_post_make_install() {
	# The ldns build doesn't install its pkg-config:
	mkdir -p $MAGISK_PREFIX/lib/pkgconfig
	cp packaging/libldns.pc $MAGISK_PREFIX/lib/pkgconfig/libldns.pc
}
