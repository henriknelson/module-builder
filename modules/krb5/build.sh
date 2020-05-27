MAGISK_MODULE_HOMEPAGE=https://web.mit.edu/kerberos
MAGISK_MODULE_DESCRIPTION="The Kerberos network authentication system"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.18.2
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://fossies.org/linux/misc/krb5-1.18.2.tar.gz
MAGISK_MODULE_SHA256=c6e4c9ec1a98141c3f5d66ddf1a135549050c9fab4e9a4620ee9b22085873ae0
MAGISK_MODULE_DEPENDS="libandroid-support, libandroid-glob, readline, openssl, libdb"
MAGISK_MODULE_BREAKS="krb5-dev"
MAGISK_MODULE_REPLACES="krb5-dev"
MAGISK_MODULE_MAINTAINER="Vishal Biswas @vishalbiswas"
MAGISK_MODULE_CONFFILES="etc/krb5.conf var/krb5kdc/kdc.conf"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--disable-static
--with-readline
--without-system-verto
--with-netlib=-lc
--enable-dns-for-realm
--sbindir=$MAGISK_PREFIX/bin
--with-size-optimizations
--with-system-db
DEFCCNAME=$MAGISK_PREFIX/tmp/krb5cc_%{uid}
DEFKTNAME=$MAGISK_PREFIX/etc/krb5.keytab
DEFCKTNAME=$MAGISK_PREFIX/var/krb5/user/%{euid}/client.keytab
"

magisk_step_post_extract_package() {
	MAGISK_MODULE_SRCDIR+="/src"
}

magisk_step_pre_configure() {
	# cannot test these when cross compiling
	export krb5_cv_attr_constructor_destructor='yes,yes'
	export ac_cv_func_regcomp='yes'
	export ac_cv_printf_positional='yes'

	# bionic doesn't have getpass
	cp "$MAGISK_MODULE_BUILDER_DIR/netbsd_getpass.c" "$MAGISK_MODULE_SRCDIR/src/clients/kpasswd/"

	CFLAGS="$CFLAGS -D_PASSWORD_LEN=PASS_MAX"
	export LIBS="-landroid-glob -llog"
}

magisk_step_post_make_install() {
	# Enable logging to STDERR by default
	echo -e "\tdefault = STDERR" >> $MAGISK_MODULE_SRCDIR/src/config-files/krb5.conf

	# Sample KDC config file
	install -dm 700 $MAGISK_PREFIX/var/krb5kdc
	install -pm 600 $MAGISK_MODULE_SRCDIR/src/config-files/kdc.conf $MAGISK_PREFIX/var/krb5kdc/kdc.conf

	# Default configuration file
	install -pm 600 $MAGISK_MODULE_SRCDIR/src/config-files/krb5.conf $MAGISK_PREFIX/etc/krb5.conf

	install -dm 700 $MAGISK_PREFIX/share/aclocal
	install -m 600 $MAGISK_MODULE_SRCDIR/src/util/ac_check_krb5.m4 $MAGISK_PREFIX/share/aclocal
}
