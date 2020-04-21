MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/global/
MAGISK_MODULE_DESCRIPTION="Source code search and browse tools"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=6.6.4
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/global/global-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=987e8cb956c53f8ebe4453b778a8fde2037b982613aba7f3e8e74bcd05312594
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_posix1_2008_realpath=yes
--with-posix-sort=$MAGISK_PREFIX/bin/sort
--with-ncurses=$MAGISK_PREFIX
"
# coreutils provides the posix sort executable:
MAGISK_MODULE_DEPENDS="coreutils, ncurses, libtool"
