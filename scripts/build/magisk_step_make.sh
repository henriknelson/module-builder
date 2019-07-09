magisk_step_make() {
	local QUIET_BUILD=
	if [ $MAGISK_QUIET_BUILD = true ]; then
		QUIET_BUILD="-s"
	fi

	mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin

	if test -f build.ninja; then
		ninja -w dupbuild=warn -j $MAGISK_MAKE_PROCESSES
	elif ls ./*akefile &> /dev/null || [ ! -z "$MAGISK_MODULE_EXTRA_MAKE_ARGS" ]; then
		if [ -z "$MAGISK_MODULE_EXTRA_MAKE_ARGS" ]; then
			make -j $MAGISK_MAKE_PROCESSES $QUIET_BUILD
		else
			make -j $MAGISK_MAKE_PROCESSES $QUIET_BUILD ${MAGISK_MODULE_EXTRA_MAKE_ARGS}
		fi
	elif test -f Cargo.toml; then
                magisk_setup_rust
		cargo clean
		cargo build \
			--verbose \
                        --target $CARGO_TARGET_NAME \
                        --release
		out_str=`cargo metadata --no-deps --format-version 1 | jq -r '.packages[].targets[] | select( .kind | map(. == "bin") | any ) | .name'`
		mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin
		OUT_FILE="target/$CARGO_TARGET_NAME/release/$out_str"
		#$STRIP $OUT_FILE
		cp -r $OUT_FILE "$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/$out_str"
		tree $MAGISK_MODULE_MASSAGEDIR
                # https://github.com/rust-lang/cargo/issues/3316:
	fi
}
