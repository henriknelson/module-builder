MAGISK_MODULE_HOMEPAGE=https://github.com/odeke-em/drive
MAGISK_MODULE_DESCRIPTION="A tiny program to pull or push Google Drive files."
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=0.3.9
MAGISK_MODULE_SRCURL=https://github.com/odeke-em/drive/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=ce7e4dd994c01d4534251c9a31adca34ed89ff6e64045813a7ce5c588ddd04be
#MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_make() {
        magisk_setup_golang
        export GOPATH=$MAGISK_MODULE_BUILDDIR
        mkdir -p "$GOPATH"/src/github.com/odeke-em/
        mkdir -p "$MAGISK_PREFIX"/usr/share/man
        cp -a "$MAGISK_MODULE_SRCDIR" "$GOPATH"/src/github.com/odeke-em/drive
        cd "$GOPATH"/src/github.com/odeke-em/drive/cmd/drive
        go get -d -v
        go build -ldflags "-linkmode external -extldflags -llog -static"
}

magisk_step_make_install() {
        install -Dm700 -t "$MAGISK_PREFIX"/bin "$GOPATH"/src/github.com/odeke-em/drive/cmd/drive
        #install -Dm600 -t "$MAGISK_PREFIX"/usr/share/man/drive "$MAGISK_MODULE_SRCDIR"/man/*
}


magisk_step_post_make_install() {
        mkdir -p $MAGISK_PREFIX/usr/share/man/man1
        cp $(find . -name drive.1) $MAGISK_PREFIX/usr/share/man/man1/
}


