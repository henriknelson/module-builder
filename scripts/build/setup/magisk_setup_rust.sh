magisk_setup_rust() {
	if [ $MAGISK_ARCH = "arm" ]; then
		CARGO_TARGET_NAME=armv7-linux-androideabi
	else
		CARGO_TARGET_NAME=$MAGISK_ARCH-unknown-linux-musl
	fi

	local ENV_NAME=CARGO_TARGET_${CARGO_TARGET_NAME^^}_LINKER
	ENV_NAME=${ENV_NAME//-/_}

	curl https://sh.rustup.rs -sSf > $MAGISK_MODULE_TMPDIR/rustup.sh

	#local _TOOLCHAIN_VERSION=$(bash -c ". $MAGISK_SCRIPTDIR/modules/rust/build.sh; echo \$MAGISK_MODULE_VERSION")

	sh $MAGISK_MODULE_TMPDIR/rustup.sh -y --default-toolchain nightly
	export PATH=$HOME/.cargo/bin:$PATH

	export RUSTFLAGS="-C link-arg=-lgcc"
	# -C link-arg=-Wl,--enable-new-dtags -C link-arg=-Wl,--static"

	echo "[target.aarch64-unknown-linux-musl]" > $HOME/.cargo/config
	echo "ar =  \"/home/builder/lib/linaro_toolchain/bin/aarch64-linux-gnu-ar\"" >> $HOME/.cargo/config
	echo "linker = \"/usr/local/musl/bin/aarch64-linux-musl-ld\"" >> $HOME/.cargo/config
	echo "rustflags = [ \"-C\", \"link-arg=-lgcc\"]" >> $HOME/.cargo/config

	rustup target add  $CARGO_TARGET_NAME

}
