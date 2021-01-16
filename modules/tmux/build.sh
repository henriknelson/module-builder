MAGISK_MODULE_HOMEPAGE=https://tmux.github.io/
MAGISK_MODULE_DESCRIPTION="Terminal multiplexer"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_DEPENDS="ncurses, libevent, libandroid-support, libandroid-glob"
MAGISK_MODULE_VERSION=3.1b
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SRCURL=https://github.com/tmux/tmux/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=100d0a11a822927172e8b983b5f9401476bd9f2cfa6758512f762b9ad74f9536
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-static --disable-shared"
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_CONFFILES="etc/tmux.conf"

magisk_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	./autogen.sh
}

magisk_step_post_make_install() {
	cp $MAGISK_MODULE_BUILDER_DIR/tmux.conf $MAGISK_PREFIX/etc/tmux.conf

	mkdir -p $MAGISK_PREFIX/usr/share/bash-completion/completions
	magisk_download \
		https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux \
		$MAGISK_PREFIX/usr/share/bash-completion/completions/tmux \
		05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae
}
