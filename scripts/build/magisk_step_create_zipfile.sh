magisk_step_create_zipfile() {
	# Get install size. This will be written as the "Installed-Size" deb field so is measured in 1024-byte blocks:
	local MAGISK_MODULE_INSTALLSIZE
	MAGISK_MODULE_INSTALLSIZE=$(du -sk . | cut -f 1)

	# From here on MAGISK_ARCH is set to "all" if MAGISK_MODULE_PLATFORM_INDEPENDENT is set by the package
	test -n "$MAGISK_MODULE_PLATFORM_INDEPENDENT" && MAGISK_ARCH=all

	MAGISK_MODULE_ZIPFILE=$MAGISK_ZIPDIR/${MAGISK_MODULE_NAME}${DEBUG}_${MAGISK_MODULE_FULLVERSION}_${MAGISK_ARCH}.zip
	# Create the actual .zip file:
        cd "$MAGISK_MODULE_MASSAGEDIR"
	magisk_log "creating zip file $MAGISK_MODULE_ZIPFILE.."
	zip --symlinks -r "$MAGISK_MODULE_ZIPFILE" .
}
