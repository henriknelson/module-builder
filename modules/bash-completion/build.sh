MAGISK_MODULE_HOMEPAGE=https://github.com/scop/bash-completion
MAGISK_MODULE_DESCRIPTION="Programmable completion for the bash shell"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.11
MAGISK_MODULE_SHA256=73a8894bad94dee83ab468fa09f628daffd567e8bef1a24277f1e9a0daf911ac
MAGISK_MODULE_SRCURL=https://github.com/scop/bash-completion/releases/download/${MAGISK_MODULE_VERSION}/bash-completion-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_DEPENDS="bash"
MAGISK_MODULE_PLATFORM_INDEPENDENT=yes
MAGISK_MODULE_BUILD_IN_SRC=yes

#MAGISK_MODULE_ESSENTIAL=yes

magisk_step_configure() {
	autoreconf -i
	$MAGISK_MODULE_SRCDIR/configure --prefix="$MAGISK_PREFIX" --host=aarch64-linux-android --target=aarch64-linux-android --datarootdir="$MAGISK_PREFIX/usr/share"
}

magisk_step_make_install() {
	make install
}
