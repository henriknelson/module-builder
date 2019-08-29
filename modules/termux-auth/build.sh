MAGISK_MODULE_HOMEPAGE=https://github.com/termux/termux-auth
MAGISK_MODULE_DESCRIPTION="Password authentication library and utility for Termux"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=1.1
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/termux/termux-auth/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=fd6fab1808b1e98dc865c47db8b4719f887273f95fe0f4dad26af016c28fa915
MAGISK_MODULE_DEPENDS="openssl"
MAGISK_MODULE_BREAKS="termux-auth-dev"
MAGISK_MODULE_REPLACES="termux-auth-dev"
MAGISK_MODULE_EXTRA_CONFIGURATION_ARGS="--host=aarch64-linux-android"
