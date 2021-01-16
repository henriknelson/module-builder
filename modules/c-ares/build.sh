MAGISK_MODULE_HOMEPAGE=https://c-ares.haxx.se
MAGISK_MODULE_DESCRIPTION="Library for asynchronous DNS requests (including name resolves)"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.16.1
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/c-ares/c-ares/archive/cares-${MAGISK_MODULE_VERSION//./_}.tar.gz
MAGISK_MODULE_SHA256=870962cc8f6b352303c404ce848e2ea1f1072f3c0a940042209a72179511c08c
MAGISK_MODULE_BREAKS="c-ares-dev"
MAGISK_MODULE_REPLACES="c-ares-dev"
# Build with cmake to install cmake/c-ares/*.cmake files:
MAGISK_MODULE_FORCE_CMAKE=true
MAGISK_MODULE_RM_AFTER_INSTALL="bin/"
