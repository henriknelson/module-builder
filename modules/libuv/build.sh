MAGISK_MODULE_HOMEPAGE=https://libuv.org
MAGISK_MODULE_DESCRIPTION="Support library with a focus on asynchronous I/O"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.40.0
MAGISK_MODULE_SRCURL=https://dist.libuv.org/dist/v${MAGISK_MODULE_VERSION}/libuv-v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=61a90db95bac00adec1cc5ddc767ebbcaabc70242bd1134a7a6b1fb1d498a194
MAGISK_MODULE_BREAKS="libuv-dev"
MAGISK_MODULE_REPLACES="libuv-dev"
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}

magisk_step_configure() {
	export CFLAGS="-fPIC"
	./configure --disable-shared --enable-static --prefix=${MAGISK_PREFIX} --host=aarch64-linux-android
}
