MAGISK_MODULE_HOMEPAGE=https://matt.ucc.asn.au/dropbear/dropbear.html
MAGISK_MODULE_DESCRIPTION="Small SSH server and client"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=2019.78
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SRCURL=https://matt.ucc.asn.au/dropbear/releases/dropbear-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=525965971272270995364a0eb01f35180d793182e63dd0b0c3eb0292291644a4
MAGISK_MODULE_DEPENDS="termux-auth, zlib"
MAGISK_MODULE_CONFLICTS="openssh"
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--disable-syslog --disable-utmp --disable-utmpx --disable-wtmp --disable-static"
# Avoid linking to libcrypt for server password authentication:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"
# build a multi-call binary & enable progress info in 'scp'
MAGISK_MODULE_EXTRA_MAKE_ARGS="MULTI=1 SCPPROGRESS=1"

magisk_step_pre_configure() {
    export LIBS="-ltermux-auth"
}

magisk_step_post_make_install() {
    ln -sf "dropbearmulti" "${MAGISK_PREFIX}/bin/ssh"
}

magisk_step_create_zipscripts() {
    {
	echo "#!$MAGISK_PREFIX/bin/sh"
	echo "mkdir -p $MAGISK_PREFIX/etc/dropbear"
	echo "for a in rsa dss ecdsa; do"
	echo "	  KEYFILE=$MAGISK_PREFIX/etc/dropbear/dropbear_\${a}_host_key"
	echo "	  test ! -f \$KEYFILE && dropbearkey -t \$a -f \$KEYFILE"
	echo "done"
	echo "exit 0"
    } > postinst
    chmod 0755 postinst
}
