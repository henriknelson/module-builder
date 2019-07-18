magisk_step_extract_module() {
	if [ -z "${MAGISK_MODULE_SRCURL:=""}" ] || [ -n "${MAGISK_MODULE_SKIP_SRC_EXTRACT:=""}" ]; then
		mkdir -p "$MAGISK_MODULE_SRCDIR"
		return
	fi

	cd "$MAGISK_MODULE_TMPDIR"
	local MODULE_SRCURL=(${MAGISK_MODULE_SRCURL[@]})
	local MODULE_SHA256=(${MAGISK_MODULE_SHA256[@]})
	if  [ ! ${#MODULE_SRCURL[@]} == ${#MODULE_SHA256[@]} ] && [ ! ${#MODULE_SHA256[@]} == 0 ]; then
		magisk_error_exit "Error: length of MAGISK_MODULE_SRCURL isn't equal to length of MAGISK_MODULE_SHA256."
	fi

	# STRIP=1 extracts archives straight into MAGISK_MODULE_SRCDIR while STRIP=0 puts them in subfolders. zip has same behaviour per default
	# If this isn't desired then this can be fixed in magisk_step_post_extract_module.
	local STRIP=1
	for i in $(seq 0 $(( ${#MODULE_SRCURL[@]}-1 ))); do
		test "$i" -gt 0 && STRIP=0
		local filename
		filename=$(basename "${MODULE_SRCURL[$i]}")
		local file="$MAGISK_MODULE_CACHEDIR/$filename"
		# Allow MAGISK_MODULE_SHA256 to be empty:
		set +u
		magisk_download "${MODULE_SRCURL[$i]}" "$file" "${MODULE_SHA256[$i]}"
		set -u

		local folder
		set +o pipefail
		magisk_log "extracting $file.."
		if [ "${file##*.}" = zip ]; then
			folder=$(unzip -qql "$file" | head -n1 | tr -s ' ' | cut -d' ' -f5-)
			rm -Rf $folder
			unzip -q "$file"
			mv $folder "$MAGISK_MODULE_SRCDIR"
		else
			mkdir -p "$MAGISK_MODULE_SRCDIR"
			tar xf "$file" -C "$MAGISK_MODULE_SRCDIR" --strip-components=$STRIP
		fi
		set -o pipefail
	done
}
