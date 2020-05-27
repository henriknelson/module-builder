MAGISK_MODULE_HOMEPAGE=https://rsync.samba.org/
MAGISK_MODULE_DESCRIPTION="Utility that provides fast incremental file transfer"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=3.1.3
MAGISK_MODULE_REVISION=6
MAGISK_MODULE_SRCURL=https://rsync.samba.org/ftp/rsync/src/rsync-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=55cc554efec5fdaad70de921cd5a5eeb6c29a95524c715f3bbf849235b0800c0
MAGISK_MODULE_DEPENDS="libiconv, libpopt, openssh | dropbear, zlib"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--with-rsyncd-conf=$MAGISK_PREFIX/etc/rsyncd.conf
--with-included-zlib=no
--disable-xattr-support
--disable-debug
"
