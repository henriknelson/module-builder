magisk_step_handle_buildarch() {
	# If $MAGISK_PREFIX already exists, it may have been built for a different arch
	local MAGISK_ARCH_FILE=$HOME/MAGISK_ARCH
	if [ -f "${MAGISK_ARCH_FILE}" ]; then
		local MAGISK_PREVIOUS_ARCH
		MAGISK_PREVIOUS_ARCH=$(cat $MAGISK_ARCH_FILE)
		if [ "$MAGISK_PREVIOUS_ARCH" != "$MAGISK_ARCH" ]; then
			local MAGISK_DATA_BACKUPDIRS=$MAGISK_TOPDIR/_databackups
			mkdir -p "$MAGISK_DATA_BACKUPDIRS"
			local MAGISK_DATA_PREVIOUS_BACKUPDIR=$MAGISK_DATA_BACKUPDIRS/$MAGISK_PREVIOUS_ARCH
			local MAGISK_DATA_CURRENT_BACKUPDIR=$MAGISK_DATA_BACKUPDIRS/$MAGISK_ARCH
			# Save current /data (removing old backup if any)
			if test -e "$MAGISK_DATA_PREVIOUS_BACKUPDIR"; then
				magisk_error_exit "Directory already exists"
			fi
			if [ -d /data/data ]; then
				mv /data/data "$MAGISK_DATA_PREVIOUS_BACKUPDIR"
			fi
			# Restore new one (if any)
			if [ -d "$MAGISK_DATA_CURRENT_BACKUPDIR" ]; then
				mv "$MAGISK_DATA_CURRENT_BACKUPDIR" /data/data
			fi
		fi
	fi

	# Keep track of current arch we are building for.
	echo "$MAGISK_ARCH" > $MAGISK_ARCH_FILE
}
