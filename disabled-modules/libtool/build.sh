MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/libtool/
MAGISK_MODULE_DESCRIPTION="Generic library support script hiding the complexity of using shared libraries behind a consistent, portable interface"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.4.6
MAGISK_MODULE_REVISION=7
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/libtool/libtool-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=e3bd4d5d3d025a36c21dd6af7ea818a2afcd4dfc1ea5a17b39d7854bcd0c06e3
MAGISK_MODULE_DEPENDS="bash,grep,sed,libltdl"
MAGISK_MODULE_CONFLICTS="libtool-dev"
MAGISK_MODULE_REPLACES="libtool-dev"

magisk_step_post_make_install() {
	perl -p -i -e "s|\"/bin/|\"$MAGISK_PREFIX/bin/|" $MAGISK_PREFIX/bin/{libtool,libtoolize}
}
