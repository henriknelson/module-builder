MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/hexyl
MAGISK_MODULE_DESCRIPTION="A command-line hex viewer"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=0.8.0
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/hexyl/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=b2e69b4ca694afd580c7ce22ab83a207174d2bbc9dabbad020fee4a98a1205be
#MAGISK_MODULE_DEPENDS="less, zlib"
MAGISK_MODULE_BUILD_IN_SRC=true

mmagisk_step_pre_configure() {
	CFLAGS="$CFLAGS -I/system/include"
	LDFLAGS="-lz $LDFLAGS -L/system/lib"
	# $CPPFLAGS"

	# See https://github.com/nagisa/rust_libloading/issues/54
	export CC_x86_64_unknown_linux_gnu=gcc
	export CFLAGS_x86_64_unknown_linux_gnu=""
}
