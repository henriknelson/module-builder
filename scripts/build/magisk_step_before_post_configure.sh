
magisk_step_before_post_configure() {
	magisk_log "module configuration completed!"
	magisk_log "checking for a config.log file.."
	if [ -e "$MAGISK_MODULE_SRCDIR/config.log" ]; then
		magisk_log "config.log found, copying to module script folder!"
                cp $MAGISK_MODULE_SRCDIR/config.log $MAGISK_SCRIPTDIR/modules/$MAGISK_MODULE_NAME/config.log
        fi
}

