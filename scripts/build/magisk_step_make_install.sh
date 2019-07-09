magisk_step_make_install() {
	if test -f build.ninja; then
		ninja -w dupbuild=warn -j $MAGISK_MAKE_PROCESSES install
	elif ls ./*akefile &> /dev/null || [ ! -z "$MAGISK_MODULE_EXTRA_MAKE_ARGS" ]; then
		: "${MAGISK_MODULE_MAKE_INSTALL_TARGET:="install"}"
		# Some modules have problem with parallell install, and it does not buy much, so use -j 1.
		if [ -z "$MAGISK_MODULE_EXTRA_MAKE_ARGS" ]; then
			make -j 1 ${MAGISK_MODULE_MAKE_INSTALL_TARGET}
		else
			make -j 1 ${MAGISK_MODULE_EXTRA_MAKE_ARGS} ${MAGISK_MODULE_MAKE_INSTALL_TARGET}
		fi
	elif test -f Cargo.toml; then
		return
		magisk_setup_rust
		cargo install \
			--path . \
			--force \
			--target $CARGO_TARGET_NAME \
			--root $MAGISK_PREFIX \
			$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS
		# https://github.com/rust-lang/cargo/issues/3316:
		rm $MAGISK_PREFIX/.crates.toml
	fi
}
