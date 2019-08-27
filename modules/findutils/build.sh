MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/findutils/
MAGISK_MODULE_DESCRIPTION="Utilities to find files meeting specified criteria and perform various actions on the files which are found"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=4.6.0
MAGISK_MODULE_REVISION=4
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/findutils/findutils-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=ded4c9f73731cd48fec3b6bdaccce896473b6d8e337e9612e16cf1431bb1169d
MAGISK_MODULE_DEPENDS="libandroid-support"
MAGISK_MODULE_ESSENTIAL=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
gl_cv_func_fflush_stdin=yes
SORT_SUPPORTS_Z=yes
SORT=$MAGISK_PREFIX/bin/applets/sort
"

# Remove locale and updatedb which in Termux is provided by mlocate:
MAGISK_MODULE_RM_AFTER_INSTALL="
bin/locate
bin/updatedb
share/man/man1/locate.1
share/man/man1/updatedb.1
share/man/man5/locatedb.5
"

magisk_step_pre_configure() {
	# This is needed for find to implement support for the
	# -fstype parameter by parsing /proc/self/mountinfo:
	CPPFLAGS+=" -DMOUNTED_GETMNTENT1=1"
}
