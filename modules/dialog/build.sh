MAGISK_MODULE_HOMEPAGE=https://invisible-island.net/dialog/
MAGISK_MODULE_DESCRIPTION="Application used in shell scripts which displays text user interface widgets"
MAGISK_MODULE_LICENSE="LGPL-2.1"
MAGISK_MODULE_DEPENDS="ncurses"
MAGISK_MODULE_VERSION="1.3-20200327"
MAGISK_MODULE_SRCURL=https://invisible-mirror.net/archives/dialog/dialog-$MAGISK_MODULE_VERSION.tgz
MAGISK_MODULE_SHA256=466163e8b97c2b7709d00389199add3156bd813f60ccb0335d0a30f2d4a17f99
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--with-ncursesw --enable-widec --with-pkg-config"

magisk_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	#if $TERMUX_ON_DEVICE_BUILD; then
	#	termux_error_exit "Package '$MAGISK_MODULE_NAME' is not safe for on-device builds."
	#fi

	# Put a temporary link for libtinfo.so
	ln -s -f $MAGISK_PREFIX/lib/libncursesw.so $MAGISK_PREFIX/lib/libtinfo.so
}

magisk_step_post_make_install() {
	rm $MAGISK_PREFIX/lib/libtinfo.so
	cd $MAGISK_PREFIX/bin
	ln -f -s dialog whiptail
}
