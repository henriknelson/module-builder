# Utility function for golang-using packages to setup a go toolchain.
magisk_setup_golang() {
	export GOOS=linux
	export CGO_ENABLED=1
	export PATH="/usr/local/musl/bin:$PATH"
	export CC=aarch64-linux-musl-gcc
	export GO_LDFLAGS=-extldflags=-pie
	export CGO_LDFLAGS="$LDFLAGS"
	export GOARCH=arm64

	local MAGISK_GO_VERSION=go1.16
	local MAGISK_GO_PLATFORM=linux-amd64

	MAGISK_BUILDGO_FOLDER=${MAGISK_COMMON_CACHEDIR}/${MAGISK_GO_VERSION}

	export GOROOT=$MAGISK_BUILDGO_FOLDER
	export PATH=${GOROOT}/bin:${PATH}

	if [ -d "$MAGISK_BUILDGO_FOLDER" ]; then return; fi

	local MAGISK_BUILDGO_TAR=$MAGISK_COMMON_CACHEDIR/${MAGISK_GO_VERSION}.${MAGISK_GO_PLATFORM}.tar.gz
	rm -Rf "$MAGISK_COMMON_CACHEDIR/go" "$MAGISK_BUILDGO_FOLDER"
	magisk_download https://golang.org/dl/${MAGISK_GO_VERSION}.${MAGISK_GO_PLATFORM}.tar.gz \
		"$MAGISK_BUILDGO_TAR" \
	        013a489ebb3e24ef3d915abe5b94c3286c070dfe0818d5bca8108f1d6e8440d2

	( cd "$MAGISK_COMMON_CACHEDIR"; tar xf "$MAGISK_BUILDGO_TAR"; mv go "$MAGISK_BUILDGO_FOLDER"; rm "$MAGISK_BUILDGO_TAR" )
}
