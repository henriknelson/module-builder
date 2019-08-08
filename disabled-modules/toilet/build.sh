MAGISK_MODULE_HOMEPAGE=http://caca.zoy.org/wiki/toilet
MAGISK_MODULE_DESCRIPTION="FIGlet-compatible display of large colourful characters in text mode"
MAGISK_MODULE_LICENSE="WTFPL"
MAGISK_MODULE_VERSION=0.3
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=http://fossies.org/linux/privat/toilet-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=89d4b530c394313cc3f3a4e07a7394fa82a6091f44df44dfcd0ebcb3300a81de
MAGISK_MODULE_DEPENDS="libcaca, zlib"
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_pre_configure() {
	CFLAGS="$CFLAGS -lz"
	LDFLAGS="$LDFLAGS -L/system/lib -lz"
}
