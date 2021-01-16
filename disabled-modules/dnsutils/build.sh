MAGISK_MODULE_HOMEPAGE=https://www.isc.org/downloads/bind/
MAGISK_MODULE_DESCRIPTION="Clients provided with BIND"
MAGISK_MODULE_LICENSE="MPL-2.0"
MAGISK_MODULE_VERSION=9.16.5
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL="ftp://ftp.isc.org/isc/bind9/${MAGISK_MODULE_VERSION}/bind-${MAGISK_MODULE_VERSION}.tar.xz"
MAGISK_MODULE_SHA256=6378b3e51fef11a8be4794dc48e8111ba92d211c0dfd129a0c296ed06a3dc075
MAGISK_MODULE_DEPENDS="openssl, readline, resolv-conf, zlib, libuv"
MAGISK_MODULE_BREAKS="dnsutils-dev"
MAGISK_MODULE_REPLACES="dnsutils-dev"
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--disable-linux-caps
--without-python
--with-ecdsa=no
--with-gost=no
--with-gssapi=no
--with-libjson=no
--with-libtool
--with-libxml2=no
--with-openssl=$MAGISK_PREFIX
--with-randomdev=/dev/random
--with-readline=-lreadline
--with-eddsa=no
--enable-shared
"

magisk_step_pre_configure() {
	export BUILD_AR=ar
	export BUILD_CC=gcc
	export BUILD_CFLAGS=
	export BUILD_CPPFLAGS=
	export BUILD_LDFLAGS=
	export BUILD_RANLIB=

	_RESOLV_CONF=$MAGISK_PREFIX/etc/resolv.conf
	CFLAGS+=" $CPPFLAGS -DRESOLV_CONF=\\\"$_RESOLV_CONF\\\""
	#export LD=$CC
	#LDFLAGS+=" -static -ldl -lreadline -lcrypto"
}

magisk_step_make() {
	make -C lib/isc
	make -C lib/dns
	make -C lib/ns
	make -C lib/isccc
	make -C lib/isccfg
	make -C lib/bind9
	make -C lib/irs
	make -C bin/dig
	make -C bin/delv
	make -C bin/nsupdate
}

magisk_step_make_install() {
	make -C lib/isc install
	make -C lib/dns install
	make -C lib/ns install
	make -C lib/isccc install
	make -C lib/isccfg install
	make -C lib/bind9 install
	make -C lib/irs install
	make -C bin/dig install
	make -C bin/delv install
	make -C bin/nsupdate install
}
