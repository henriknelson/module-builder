MAGISK_MODULE_HOMEPAGE=https://github.com/gdrive-org/gdrive
MAGISK_MODULE_DESCRIPTION="gdrive is a command line utility for interacting with Google Drive."
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=2.1.0
MAGISK_MODULE_SHA256=a1ea624e913e258596ea6340c8818a90c21962b0a75cf005e49a0f72f2077b2e
MAGISK_MODULE_SRCURL=https://github.com/gdrive-org/gdrive/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_DEPENDS=" libandroid-glob"
magisk_step_pre_configure() {
	CPPFLAGS+=" -I$MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/include"
        LDFLAGS+=" -L$MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/lib -llog -ldl -static"
}

magisk_step_make() {
	magisk_setup_golang

	export GOPATH=$MAGISK_MODULE_BUILDDIR

	export CGO_CFLAGS="$CFLAGS $CPPFLAGS -D__GLIBC__"
        export CGO_CXXFLAGS="$CXXFLAGS $CPPFLAGS -D__GLIBC__"
        export CGO_LDFLAGS="$LDFLAGS"

	go get github.com/prasmussen/gdrive

	#mkdir -p "$GOPATH"/src/github.com/prasmussen/
	#cp -ar "$MAGISK_MODULE_SRCDIR" "$GOPATH"/src/github.com/prasmussen/gdrive
	cd "$GOPATH"/src/github.com/prasmussen/gdrive
	ls -la
	#go build .
	# install VERSION=$MAGISK_MODULE_VERSION
}

magisk_step_make_install() {
	install -Dm700 \
		"$GOPATH"/bin/${GOOS}_${GOARCH}/gdrive \
		"$MAGISK_PREFIX"/bin/gdrive

	#fdfind -e 1 . .

	#install -Dm600 \
	#	"$MAGISK_MODULE_SRCDIR"/man/gdrive.1 \
	#	"$MAGISK_PREFIX"/usr/share/man/man1/gdrive.1
}

