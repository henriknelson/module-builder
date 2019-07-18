magisk_error_exit() {
	magisk_log "ERROR: $*" 1>&2
	caller
	exit 1
}
