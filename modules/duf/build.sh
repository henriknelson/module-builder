MAGISK_MODULE_HOMEPAGE=https://github.com/muesli/duf
MAGISK_MODULE_DESCRIPTION="Disk usage/free utility"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="Krishna kanhaiya @kcubeterm"
MAGISK_MODULE_VERSION=0.4.0
MAGISK_MODULE_SRCURL=https://github.com/muesli/duf/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=da6b0bb601d7b9a92cfd41005eae7a66573d28e77625f4e747b285207980784b

magisk_step_make() {
        magisk_setup_golang

        cd "$MAGISK_MODULE_SRCDIR"

        mkdir -p "${MAGISK_MODULE_BUILDDIR}/src/github.com/muesli"
        cp -a "${MAGISK_MODULE_SRCDIR}" "${MAGISK_MODULE_BUILDDIR}/src/github.com/muesli/duf"
        cd "${MAGISK_MODULE_BUILDDIR}/src/github.com/muesli/duf"

        go get -d -v
        go build -ldflags "-L /system/lib -linkmode external -extldflags \"-lc -static\""
}

magisk_step_make_install() {
        install -Dm700 ${MAGISK_MODULE_BUILDDIR}/src/github.com/muesli/duf/duf \
                         $MAGISK_PREFIX/bin/duf
        mkdir -p $MAGISK_PREFIX/usr/share/doc/duf

        install ${MAGISK_MODULE_BUILDDIR}/src/github.com/muesli/duf/README.md \
                        $MAGISK_PREFIX/usr/share/doc/duf
}
