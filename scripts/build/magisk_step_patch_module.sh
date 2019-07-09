magisk_step_patch_module() {
	cd "$MAGISK_MODULE_SRCDIR"
	local DEBUG_PATCHES=""
	if [ "$MAGISK_DEBUG" == "true" ] && [ -f $MAGISK_MODULE_BUILDER_DIR/*.patch.debug ] ; then
		DEBUG_PATCHES="$(ls $MAGISK_MODULE_BUILDER_DIR/*.patch.debug)"
	fi
	# Suffix patch with ".patch32" or ".patch64" to only apply for these bitnesses:
	shopt -s nullglob
	for patch in $MAGISK_MODULE_BUILDER_DIR/*.patch{$MAGISK_ARCH_BITS,} $DEBUG_PATCHES; do
		echo "Applying patch file $patch.."
		test -f "$patch" && sed "s%\@MAGISK_PREFIX\@%${MAGISK_PREFIX}%g" "$patch" | \
			sed "s%\@MAGISK_HOME\@%${MAGISK_ANDROID_HOME}%g" | \
			patch -p1
	done
	shopt -u nullglob
}
