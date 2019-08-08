MAGISK_MODULE_HOMEPAGE=https://www.pureftpd.org/project/pure-ftpd
MAGISK_MODULE_DESCRIPTION="Pure-FTPd is a free (BSD), secure, production-quality and standard-conformant FTP server"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.0.49
MAGISK_MODULE_SHA256=767bf458c70b24f80c0bb7a1bbc89823399e75a0a7da141d30051a2b8cc892a5
MAGISK_MODULE_SRCURL=https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_DEPENDS="libcrypt, openssl"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--includedir=$MAGISK_PREFIX/include
ac_cv_lib_elf_elf_begin=no
ac_cv_lib_sodium_crypto_pwhash_scryptsalsa208sha256_str=no
--with-ftpwho
--with-nonroot
--with-puredb
--with-tls
--disable-crypt
"
MAGISK_MODULE_EXTRA_MAKE_ARGS="
V=1
"
MAGISK_MODULE_CONFFILES="etc/pure-ftpd.conf"

mmagisk_step_pre_configure() {
	CFLAGS+="-I$MAGISK_PREFIX/include"
}
