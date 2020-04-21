MAGISK_MODULE_HOMEPAGE=https://mdocml.bsd.lv/
MAGISK_MODULE_DESCRIPTION="Man page viewer from the mandoc toolset"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=2.8.7
MAGISK_MODULE_SHA256=dcc19062e0e1ed7fffe356508b26ac12bce9b8971669df8afa0e70a17a622601
MAGISK_MODULE_SRCURL=https://git.savannah.gnu.org/cgit/man-db.git/snapshot/man-db-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_DEPENDS="libpipeline,libandroid-glob,libiconv,gdbm,flex"
MAGISK_MODULE_BUILD_IN_SRC=yes

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--prefix=$MAGISK_PREFIX
--libexecdir=$MAGISK_PREFIX/usr/libexec
--host=aarch64-linux-android
--enable-static
--disable-shared
--with-systemdtmpfilesdir=no
--with-systemdsystemunitdir=no
--disable-cache-owner
--with-config-file=$MAGISK_PREFIX/etc/man_db.conf
--enable-automatic-create
--disable-nls
--disable-rpath
--with-db=gdbm
--without-libseccomp
"

magisk_step_pre_configure() {
	export LIBS="-landroid-glob -lpipeline -liconv -lgdbm"
	LDFLAGS+=" --static"
	$MAGISK_MODULE_SRCDIR/bootstrap
}
