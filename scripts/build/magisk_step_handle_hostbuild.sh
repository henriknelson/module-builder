magisk_step_handle_hostbuild() {
	if [ "x$MAGISK_MODULE_HOSTBUILD" = "x" ]; then return; fi

	cd "$MAGISK_MODULE_SRCDIR"
	for patch in $MAGISK_MODULE_BUILDER_DIR/*.patch.beforehostbuild; do
		test -f "$patch" && sed "s%\@MAGISK_PREFIX\@%${MAGISK_PREFIX}%g" "$patch" | patch --silent -p1
	done

	local MAGISK_HOSTBUILD_MARKER="$MAGISK_MODULE_HOSTBUILD_DIR/MAGISK_BUILT_FOR_$MAGISK_MODULE_VERSION"
	if [ ! -f "$MAGISK_HOSTBUILD_MARKER" ]; then
		rm -Rf "$MAGISK_MODULE_HOSTBUILD_DIR"
		mkdir -p "$MAGISK_MODULE_HOSTBUILD_DIR"
		cd "$MAGISK_MODULE_HOSTBUILD_DIR"
		magisk_step_host_build
		touch "$MAGISK_HOSTBUILD_MARKER"
	fi
}
