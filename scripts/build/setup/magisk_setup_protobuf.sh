magisk_setup_protobuf() {
	local _PROTOBUF_VERSION=$(bash -c ". $MAGISK_SCRIPTDIR/modules/libprotobuf/build.sh; echo \${MAGISK_MODULE_VERSION:2}")
	local _PROTOBUF_ZIP=protoc-$_PROTOBUF_VERSION-linux-x86_64.zip
	_PROTOBUF_FOLDER=${MAGISK_COMMON_CACHEDIR}/protobuf-${_PROTOBUF_VERSION}

	if [ ! -d "$_PROTOBUF_FOLDER" ]; then
		magisk_download \
			https://github.com/protocolbuffers/protobuf/releases/download/v$_PROTOBUF_VERSION/$_PROTOBUF_ZIP \
			$MAGISK_MODULE_TMPDIR/$_PROTOBUF_ZIP \
			a2900100ef9cda17d9c0bbf6a3c3592e809f9842f2d9f0d50e3fba7f3fc864f0

		rm -Rf "$MAGISK_MODULE_TMPDIR/protoc-$_PROTOBUF_VERSION-linux-x86_64"
		unzip $MAGISK_MODULE_TMPDIR/$_PROTOBUF_ZIP -d $MAGISK_MODULE_TMPDIR/protobuf-$_PROTOBUF_VERSION
		mv "$MAGISK_MODULE_TMPDIR/protobuf-$_PROTOBUF_VERSION" \
			$_PROTOBUF_FOLDER
	fi

	export PATH=$_PROTOBUF_FOLDER/bin/:$PATH
}
