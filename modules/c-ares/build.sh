MAGISK_MODULE_HOMEPAGE=https://c-ares.haxx.se
MAGISK_MODULE_DESCRIPTION="Library for asynchronous DNS requests (including name resolves)"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_MAINTAINER="@termux"
MAGISK_MODULE_VERSION=1.17.1
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://github.com/c-ares/c-ares/archive/cares-${MAGISK_MODULE_VERSION//./_}.tar.gz
MAGISK_MODULE_SHA256=61f7cf09605f5e38d4828f82d0e2ddb9de8e355ecfd6819b740691c644583b8f
MAGISK_MODULE_BREAKS="c-ares-dev"
MAGISK_MODULE_REPLACES="c-ares-dev"
# Build with cmake to install cmake/c-ares/*.cmake files:
MAGISK_MODULE_BUILD_IN_SRC=true
#MAGISK_MODULE_FORCE_CMAKE=true
#MAGISK_MODULE_RM_AFTER_INSTALL="bin/"

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--disable-shared
"

magisk_step_pre_configure() {
	autoreconf -fi
	export CFLAGS+=" -static"
	export CPPFLAGS+=" -DANDROID -D_ANDROID -DCARES_STATIC=true"
	export LDFLAGS+=" $LDFLAGS -static"
	#export LIBS=" -lssl -lcrypto -ldl"
}
