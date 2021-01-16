MAGISK_MODULE_HOMEPAGE=https://dev.yorhel.nl/ncdu
MAGISK_MODULE_DESCRIPTION="Disk usage analyzer"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.0
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/jhawthorn/fzy/releases/download/1.0/fzy-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=80257fd74579e13438b05edf50dcdc8cf0cdb1870b4a2bc5967bd1fdbed1facf
MAGISK_MODULE_DEPENDS="ncurses, libandroid-support"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS=" --prefix=$MAGISK_PREFIX --mandir=$MAGISK_PREFIX/usr/share"
MAGISK_MODULE_BUILD_IN_SRC=y

magisk_step_pre_configure() {
	export CFLAGS+=" -static"
	export LDFLAGS+=" -L/system/lib -lc -ldl -static"
}

mmagisk_step_make() {
	make && make install
}

mmagisk_step_post_make_install() {
	tree $(pwd)
}
