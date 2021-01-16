MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/vivid
MAGISK_MODULE_DESCRIPTION="A generator for the LS_COLORS environment variable that controls the colorized output of ls, tree, fd, etc."
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=0.6.0
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/vivid/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=c8640f524aef1cd4dc15286bdc6189894ad067ea79bf8c40b9ca8d9d752d161f
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	CFLAGS="$CFLAGS -I/system/include"
	LDFLAGS="-lz $LDFLAGS -L/system/lib"

	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu=""
}

mmagisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/usr/share/man/man1
	cp $(find . -name vivid.1) $MAGISK_PREFIX/usr/share/man/man1/
}
