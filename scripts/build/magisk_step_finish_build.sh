magisk_step_finish_build() {
	echo "Magisk - build of '$MAGISK_MODULE_NAME' done"
	test -t 1 && printf "\033]0;%s - DONE\007" "$MAGISK_MODULE_NAME"
	mkdir -p /data/data/.built-modules
	echo "$MAGISK_MODULE_FULLVERSION" > "/data/data/.built-modules/$MAGISK_MODULE_NAME"
	exit 0
}
