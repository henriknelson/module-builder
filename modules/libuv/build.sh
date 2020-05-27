MAGISK_MODULE_HOMEPAGE=https://libuv.org
MAGISK_MODULE_DESCRIPTION="Support library with a focus on asynchronous I/O"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.37.0
MAGISK_MODULE_SRCURL=https://dist.libuv.org/dist/v${MAGISK_MODULE_VERSION}/libuv-v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=6f2794313c9603388ed4b7b818b3bed5f784f886ae3ce5b3424b331813f6a391
MAGISK_MODULE_BREAKS="libuv-dev"
MAGISK_MODULE_REPLACES="libuv-dev"

magisk_step_pre_configure() {
	export PLATFORM=android
	sh autogen.sh
}
