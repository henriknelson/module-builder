MAGISK_MODULE_HOMEPAGE=https://www.nlnetlabs.nl/projects/ldns/
MAGISK_MODULE_DESCRIPTION="Library for simplifying DNS programming and supporting recent and experimental RFCs"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_MAINTAINER="@termux"
MAGISK_MODULE_VERSION=1.7.1
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SRCURL=https://www.nlnetlabs.nl/downloads/ldns/ldns-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=8ac84c16bdca60e710eea75782356f3ac3b55680d40e1530d7cea474ac208229
MAGISK_MODULE_DEPENDS="openssl"
MAGISK_MODULE_BREAKS="ldns-dev"
MAGISK_MODULE_REPLACES="ldns-dev"
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--with-ssl=$MAGISK_PREFIX
--enable-shared
--enable-static
--disable-gost
--with-drill
"

mmagisk_step_pre_configure() {
	export CFLAGS+=" -DHAVE_ENDPROTOENT=0"
	export CPPFLAGS=" -DHAVE_ENDPROTOENT=0"
	export LDFLAGS+=" -static -levent -lssl -lcrypto -lz"
}

magisk_step_post_make_install() {
	# The ldns build doesn't install its pkg-config:
	mkdir -p $MAGISK_PREFIX/lib/pkgconfig
	find . -name "*libldns.pc*"
	cp packaging/libldns.pc.in $MAGISK_PREFIX/lib/pkgconfig/libldns.pc
}

mmagisk_step_pre_configure() {
	export LDFLAGS="$LDFLAGS -static"
	export PATH=/usr/local/musl/bin:$PATH
        TARGET=aarch64-linux-musl
	export CC=${TARGET}-gcc
	export GCC=${TARGET}-gcc
	export LD=${TARGET}-ld
	export AR=${TARGET}-ar
	export RANLIB=${TARGET}-ranlib
	export CFLAGS=" -z execstack"
	C_INCLUDE_PATH=/usr/local/musl/aarch64-linux-musl/include
	#./configure --prefix=$MAGISK_PREFIX --static
}
