magisk_step_replace_guess_scripts() {
	cd "$MAGISK_MODULE_SRCDIR"
	find . -name config.sub -exec chmod u+w '{}' \; -exec cp "$MAGISK_SCRIPTDIR/scripts/config.sub" '{}' \;
	find . -name config.guess -exec chmod u+w '{}' \; -exec cp "$MAGISK_SCRIPTDIR/scripts/config.guess" '{}' \;
}
