MAGISK_MODULE_HOMEPAGE=http://www.linuxfromscratch.org/blfs/view/svn/general/popt.html
MAGISK_MODULE_DESCRIPTION="Library for parsing cmdline parameters"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.16
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SRCURL=https://fossies.org/linux/misc/popt-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8
MAGISK_MODULE_DEPENDS="libandroid-glob"
MAGISK_MODULE_BREAKS="libpopt-dev"
MAGISK_MODULE_REPLACES="libpopt-dev"

magisk_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
