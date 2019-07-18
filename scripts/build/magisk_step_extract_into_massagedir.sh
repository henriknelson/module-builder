magisk_step_extract_into_massagedir() {
	local TARBALL_ORIG=$MAGISK_MODULE_MODULEDIR/${MAGISK_MODULE_NAME}_orig.tar.gz

	# Build diff tar with what has changed during the build:
	cd $MAGISK_PREFIX
	tar -N "$MAGISK_BUILD_TS_FILE" \
		--exclude='lib/libutil.so' \
		-cvzf "$TARBALL_ORIG" .

	# Extract tar in order to massage it
	mkdir -p "$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX"
	cd "$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX"
	tar -xf "$TARBALL_ORIG"
	rm "$TARBALL_ORIG"
}
