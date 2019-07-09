magisk_step_configure_meson() {
	magisk_setup_meson
	CC=gcc CXX=g++ $MAGISK_MESON \
		$MAGISK_MODULE_SRCDIR \
		$MAGISK_MODULE_BUILDDIR \
		--cross-file $MAGISK_MESON_CROSSFILE \
		--prefix $MAGISK_PREFIX \
		--libdir lib \
		--buildtype minsize \
		--strip \
		$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS
}
