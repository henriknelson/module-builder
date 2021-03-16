magisk_step_configure() {
	env
	echo "$MAGISK_MODULE_FORCE_CMAKE"
	if [ "$MAGISK_MODULE_FORCE_CMAKE" = "true" ] || [ -f "$MAGISK_MODULE_SRCDIR/configure" ]; then
		magisk_step_configure_autotools
	elif [ -f "$MAGISK_MODULE_SRCDIR/CMakeLists.txt" ]; then
		magisk_step_configure_cmake
	elif [ -f "$MAGISK_MODULE_SRCDIR/meson.build" ]; then
		magisk_step_configure_meson
	fi
}
