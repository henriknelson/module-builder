MAGISK_MODULE_HOMEPAGE=https://cli.github.com/
MAGISK_MODULE_DESCRIPTION="GitHub’s official command line tool"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Krishna kanhaiya @kcubeterm"
MAGISK_MODULE_VERSION=1.1.0
MAGISK_MODULE_SRCURL=https://github.com/cli/cli/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=3340bcec77dd9cbb5074399effc876cb7d759a235d24ea11253ad7b232b620a2
magisk_step_make() {
	magisk_setup_golang

	cd "$MAGISK_MODULE_SRCDIR"
	(
		unset GOOS GOARCH CGO_LDFLAGS
		unset CC CXX CFLAGS CXXFLAGS LDFLAGS
		go run ./cmd/gen-docs --man-page --doc-path $MAGISK_PREFIX/share/man/man1/
	)
	export GOPATH=$MAGISK_MODULE_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/cli/
	mkdir -p "$MAGISK_PREFIX"/share/doc/gh
	cp -a "$MAGISK_MODULE_SRCDIR" "$GOPATH"/src/github.com/cli/cli
	cd "$GOPATH"/src/github.com/cli/cli/cmd/gh
	go get -d -v
	go build -ldflags "-L /system/lib -linkmode external -extldflags \"-lc -static\""
}

magisk_step_make_install() {
	install -Dm700 -t "$MAGISK_PREFIX"/bin "$GOPATH"/src/github.com/cli/cli/cmd/gh/gh
	install -Dm600 -t "$MAGISK_PREFIX"/share/doc/gh/ "$MAGISK_MODULE_SRCDIR"/docs/*
}
