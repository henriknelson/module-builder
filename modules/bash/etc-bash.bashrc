if [ -x @MAGISK_PREFIX@/libexec/magisk/command-not-found ]; then
	command_not_found_handle() {
		@MAGISK_PREFIX@/libexec/magisk/command-not-found "$1"
	}
fi

PS1='\$ '
