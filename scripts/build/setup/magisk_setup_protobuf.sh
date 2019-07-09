magisk_setup_protobuf() {
	local _PROTOBUF_VERSION=$(bash -c ". $MAGISK_SCRIPTDIR/modules/libprotobuf/build.sh; echo \$MAGISK_MODULE_VERSION")
	local _PROTOBUF_ZIP=protoc-$_PROTOBUF_VERSION-linux-x86_64.zip
	local _PROTOBUF_FOLDER=$MAGISK_COMMON_CACHEDIR/protobuf-$_PROTOBUF_VERSION

	if [ ! -d "$_PROTOBUF_FOLDER" ]; then
		magisk_download \
				https://github.com/protocolbuffers/protobuf/releases/download/v$_PROTOBUF_VERSION/$_PROTOBUF_ZIP \
				$MAGISK_MODULE_TMPDIR/$_PROTOBUF_ZIP \
				24ea6924faaf94d4a0c5850fdb278290a326eff9a68f36ee5809654faccd0e10

		rm -Rf "$MAGISK_MODULE_TMPDIR/protoc-$_PROTOBUF_VERSION-linux-x86_64"
		unzip $MAGISK_MODULE_TMPDIR/$_PROTOBUF_ZIP -d $MAGISK_MODULE_TMPDIR/protobuf-$_PROTOBUF_VERSION
		mv "$MAGISK_MODULE_TMPDIR/protobuf-$_PROTOBUF_VERSION" \
			$_PROTOBUF_FOLDER
	fi

	export PATH=$_PROTOBUF_FOLDER/bin/:$PATH
}
