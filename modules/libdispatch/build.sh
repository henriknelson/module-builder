MAGISK_MODULE_HOMEPAGE=https://github.com/apple/swift-corelibs-libdispatch
MAGISK_MODULE_DESCRIPTION="The libdispatch project, for concurrency on multicore hardware"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_MAINTAINER="@buttaface"
_VERSION=5.3.3
MAGISK_MODULE_VERSION=1:${_VERSION}
MAGISK_MODULE_SRCURL=https://github.com/apple/swift-corelibs-libdispatch/archive/swift-${_VERSION}-RELEASE.tar.gz
MAGISK_MODULE_SHA256=84a482afefdcda26c7dc83e3b75e662ed7705786a34a6b4958c0cdc6cace2c46
MAGISK_MODULE_DEPENDS="libc++, libblocksruntime"

magisk_module_pre_configure() {
	export LDFLAGS+=" -static"
}
