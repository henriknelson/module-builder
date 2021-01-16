MAGISK_MODULE_HOMEPAGE=http://www.linuxfromscratch.org/blfs/view/svn/general/popt.html
MAGISK_MODULE_DESCRIPTION="Library for parsing cmdline parameters"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.18
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SRCURL=https://fossies.org/linux/misc/popt-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=5159bc03a20b28ce363aa96765f37df99ea4d8850b1ece17d1e6ad5c24fdc5d1
MAGISK_MODULE_DEPENDS="libandroid-glob"
MAGISK_MODULE_BREAKS="libpopt-dev"
MAGISK_MODULE_REPLACES="libpopt-dev"

magisk_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
