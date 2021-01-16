MAGISK_MODULE_HOMEPAGE=https://github.com/nojima/httpie-go
MAGISK_MODULE_DESCRIPTION="A command-line benchmarking tool"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=0.6.0
MAGISK_MODULE_SRCURL=https://github.com/nojima/httpie-go/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=3e32c55ad98ff056f42681f51304f82c715ce54d703cf3ce23e8b9930b620d6f

magisk_step_post_extract_module() {
        magisk_setup_golang

        cd "$MAGISK_MODULE_SRCDIR"

        mkdir -p "${MAGISK_MODULE_BUILDDIR}/src/github.com/nojima"
        cp -a "${MAGISK_MODULE_SRCDIR}" "${MAGISK_MODULE_BUILDDIR}/src/github.com/nojima/httpie-go"
        cd "${MAGISK_MODULE_BUILDDIR}/src/github.com/nojima/httpie-go"
}

magisk_step_patch_module() {
        cd "${MAGISK_MODULE_BUILDDIR}/src/github.com/nojima/httpie-go"
	cp ${MAGISK_MODULE_BUILDER_DIR}/*.patch .

	shopt -s nullglob
	for patch in $(pwd)/*.patch; do
                magisk_log "Applying patchfile $patch.."
		#test -f "$patch" && sed "s%\@MAGISK_PREFIX\@%${MAGISK_PREFIX}%g" "$patch" | \ 
		#sed "s%\@MAGISK_HOME\@%${MAGISK_ANDROID_HOME}%g" | \ 
		#sed "s%\@MAGISK_MODULE_VERSION\@%${MAGISK_MODULE_VERSION}%g" | \ 
		patch --silent -p1 -i $patch
        done
	shopt -u nullglob
}

magisk_step_make() {
        cd "${MAGISK_MODULE_BUILDDIR}/src/github.com/nojima/httpie-go"
	go build -ldflags "-L /system/lib -linkmode external -extldflags \"-lc -lm -ldl -static\"" -o ht ./cmd/ht
}

magisk_step_make_install() {
        install -Dm700 ${MAGISK_MODULE_BUILDDIR}/src/github.com/nojima/httpie-go/ht $MAGISK_PREFIX/bin/ht
}
