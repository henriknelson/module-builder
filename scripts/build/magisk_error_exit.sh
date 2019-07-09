magisk_error_exit() {
	echo "ERROR: $*" 1>&2
	caller
	exit 1
}
