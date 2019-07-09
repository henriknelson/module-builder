# Utility function for golang-using packages to setup a go toolchain.
magisk_setup_golang() {
	export GOOS=android
	export CGO_ENABLED=1
	export GO_LDFLAGS="-extldflags=-pie"
	export CGO_LDFLAGS="$LDFLAGS"
	if [ "$MAGISK_ARCH" = "arm" ]; then
		export GOARCH=arm
		export GOARM=7
	elif [ "$MAGISK_ARCH" = "i686" ]; then
		export GOARCH=386
		export GO386=sse2
	elif [ "$MAGISK_ARCH" = "aarch64" ]; then
		export GOARCH=arm64
	elif [ "$MAGISK_ARCH" = "x86_64" ]; then
		export GOARCH=amd64
	else
		magisk_error_exit "Unsupported arch: $MAGISK_ARCH"
	fi

	local MAGISK_GO_VERSION=go1.12.6
	local MAGISK_GO_PLATFORM=linux-amd64

	local MAGISK_BUILDGO_FOLDER=$MAGISK_COMMON_CACHEDIR/${MAGISK_GO_VERSION}
	export GOROOT=$MAGISK_BUILDGO_FOLDER
	export PATH=$GOROOT/bin:$PATH

	if [ -d "$MAGISK_BUILDGO_FOLDER" ]; then return; fi

	local MAGISK_BUILDGO_TAR=$MAGISK_COMMON_CACHEDIR/${MAGISK_GO_VERSION}.${MAGISK_GO_PLATFORM}.tar.gz
	rm -Rf "$MAGISK_COMMON_CACHEDIR/go" "$MAGISK_BUILDGO_FOLDER"
	magisk_download https://storage.googleapis.com/golang/${MAGISK_GO_VERSION}.${MAGISK_GO_PLATFORM}.tar.gz \
		"$MAGISK_BUILDGO_TAR" \
		dbcf71a3c1ea53b8d54ef1b48c85a39a6c9a935d01fc8291ff2b92028e59913c

	( cd "$MAGISK_COMMON_CACHEDIR"; tar xf "$MAGISK_BUILDGO_TAR"; mv go "$MAGISK_BUILDGO_FOLDER"; rm "$MAGISK_BUILDGO_TAR" )
}
