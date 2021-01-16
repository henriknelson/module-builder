MAGISK_MODULE_HOMEPAGE=http://man7.org/linux/man-pages/man5/resolv.conf.5.html
MAGISK_MODULE_DESCRIPTION="Resolver configuration file"
MAGISK_MODULE_LICENSE="Public Domain"
MAGISK_MODULE_VERSION=1.3
MAGISK_MODULE_SKIP_SRC_EXTRACT=true
MAGISK_MODULE_CONFFILES="etc/resolv.conf"

magisk_step_make_install() {
	_RESOLV_CONF=$MAGISK_PREFIX/etc/resolv.conf
	printf "nameserver 8.8.8.8\nnameserver 8.8.4.4" > $_RESOLV_CONF
}
