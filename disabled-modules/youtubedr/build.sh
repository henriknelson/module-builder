MAGISK_MODULE_HOMEPAGE=https://github.com/kkdai/youtube
MAGISK_MODULE_DESCRIPTION="Download youtube video in Golang"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Krishna kanhaiya @kcubeterm"
MAGISK_MODULE_VERSION=1.2.1
MAGISK_MODULE_SRCURL=https://github.com/kkdai/youtube/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=20946b843b9584dd044ec4d8b412365511338c568a37a6170acabea2bb3e2661

magisk_step_pre_configure() {
	CPPFLAGS+=" -I$MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/include"
        LDFLAGS+=" -L$MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/lib -llog -ldl -static"
}

magisk_step_make() {
	magisk_setup_golang
        export CGO_CFLAGS="$CFLAGS $CPPFLAGS -D__GLIBC__"
        export CGO_CXXFLAGS="$CXXFLAGS $CPPFLAGS -D__GLIBC__"
        export CGO_LDFLAGS="$LDFLAGS"

	cd "$MAGISK_MODULE_SRCDIR"

	export GOPATH="${MAGISK_MODULE_BUILDDIR}"
	mkdir -p "${GOPATH}/src/github.com/kkdai/"
	cp -a "${MAGISK_MODULE_SRCDIR}" "${GOPATH}/src/github.com/kkdai/youtube"
	cd "${GOPATH}/src/github.com/kkdai/youtube/"
	go get -d -v
	cd youtubedr
	go build . #-ldflags="-extldflags=-static" .
	sudo chown builder:builder -R ${MAGISK_MODULE_BUILDDIR}
}

magisk_step_make_install() {
	install -Dm700 -t "$MAGISK_PREFIX"/bin "$GOPATH"/src/github.com/kkdai/youtube/youtubedr/youtubedr
}
