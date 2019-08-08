MAGISK_MODULE_HOMEPAGE=https://c-ares.haxx.se/
MAGISK_MODULE_DESCRIPTION="This is c-ares, an asynchronous resolver library"
MAGISK_MODULE_LICENSE="MIT"
_MAJOR_VERSION=1
_MINOR_VERSION=15
_BUILD_VERSION=0
MAGISK_MODULE_VERSION=${_MAJOR_VERSION}.${_MINOR_VERSION}.${_BUILD_VERSION}
MAGISK_MODULE_SRCURL=https://github.com/c-ares/c-ares/releases/download/cares-${_MAJOR_VERSION}_${_MINOR_VERSION}_${_BUILD_VERSION}/c-ares-$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=6cdb97871f2930530c97deb7cf5c8fa4be5a0b02c7cea6e7c7667672a39d6852
MAGISK_MODULE_BUILD_IN_SRC=true

# Starting with version 7.62 curl started enabling http/2 by default.
# Support for http/2 as added in version 1.4.8-8 of the apt package, so we
# conflict with previous versions to avoid broken installations.
#MAGISK_MODULE_CONFLICTS="apt (<< 1.4.8-8)"

magisk_step_configure() {
	./configure --prefix $MAGISK_PREFIX --host=aarch64-linux-android --target=aarch64-linux-android --includedir=/system/include --libdir=/system/lib --disable-shared --with-pic
}
