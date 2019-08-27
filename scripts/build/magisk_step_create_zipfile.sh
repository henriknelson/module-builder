magisk_step_create_zipfile() {
	# From here on MAGISK_ARCH is set to "all" if MAGISK_MODULE_PLATFORM_INDEPENDENT is set by the package
	test -n "$MAGISK_MODULE_PLATFORM_INDEPENDENT" && MAGISK_ARCH=all

	MAGISK_MODULE_ZIPFILE=$MAGISK_ZIPDIR/${MAGISK_MODULE_NAME}${DEBUG}_${MAGISK_MODULE_FULLVERSION}_${MAGISK_ARCH}.zip

	# Create the actual .zip file:
	magisk_step_create_zipscripts
	cd "$MAGISK_MODULE_MASSAGEDIR"

	magisk_log "creating zip file $MAGISK_MODULE_ZIPFILE.."
	zip --symlinks -r "$MAGISK_MODULE_ZIPFILE" .
}
