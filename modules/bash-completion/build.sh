MAGISK_MODULE_HOMEPAGE=https://github.com/scop/bash-completion
MAGISK_MODULE_DESCRIPTION="Programmable completion for the bash shell"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.10
MAGISK_MODULE_SHA256=123c17998e34b937ce57bb1b111cd817bc369309e9a8047c0bcf06ead4a3ec92
MAGISK_MODULE_SRCURL=https://github.com/scop/bash-completion/releases/download/2.10/bash-completion-2.10.tar.xz
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
