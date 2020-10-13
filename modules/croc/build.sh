MAGISK_MODULE_HOMEPAGE=https://github.com/schollz/croc
MAGISK_MODULE_DESCRIPTION="Easily and securely send things from one computer to another."
MAGISK_MODULE_LICENSE=MIT
MAGISK_MODULE_VERSION=8.5.1
MAGISK_MODULE_SRCURL=https://github.com/schollz/croc/releases/download/v${MAGISK_MODULE_VERSION}/croc_${MAGISK_MODULE_VERSION}_src.tar.gz
MAGISK_MODULE_SHA256=b76e5523a8c621ddbaf6dacf3e70c6f614b8a35d494be43412082e9bf7323df2
MAGISK_MODULE_DEPENDS="libandroid-support"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_make() {
	cd $MAGISK_MODULE_SRCDIR

	magisk_setup_golang

	go build -v -o croc -trimpath -ldflags "-L /system/lib -linkmode external -extldflags \"-lc -static\""
}

magisk_step_make_install() {
	install -m755 croc $MAGISK_PREFIX/bin/croc
}
