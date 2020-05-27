MAGISK_MODULE_HOMEPAGE=http://www.greenwoodsoftware.com/less/
MAGISK_MODULE_DESCRIPTION="Terminal pager program used to view the contents of a text file one screen at a time"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=561
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=http://www.greenwoodsoftware.com/less/less-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=c24683c98d5f377adc54a0c28e84391346a98f7d6fd0bb0df1831c8a5cfc9836
MAGISK_MODULE_DEPENDS="ncurses"

magisk_step_post_extract_module() {
	sudo chown -R builder:builder .
}

magisk_step_pre_configure(){
	CFLAGS+=" -static"
	LDFLAGS+=" --static -lc"
}
