MAGISK_MODULE_HOMEPAGE=https://www.nongnu.org/renameutils/
MAGISK_MODULE_DESCRIPTION="A set of programs designed to make renaming of files faster and less cumbersome"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=0.12.0
MAGISK_MODULE_SRCURL=https://savannah.nongnu.org/download/renameutils/renameutils-$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=cbd2f002027ccf5a923135c3f529c6d17fabbca7d85506a394ca37694a9eb4a3
MAGISK_MODULE_DEPENDS="readline"

magisk_step_pre_configure() {
	LDFLAGS+=" -static"
}
