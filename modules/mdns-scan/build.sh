MAGISK_MODULE_HOMEPAGE="https://github.com/alteholz/mdns-scan"
MAGISK_MODULE_DESCRIPTION="A tool for scanning for mDNS/DNS-SD services published on the local network"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=0.5
MAGISK_MODULE_SRCURL=https://github.com/alteholz/mdns-scan/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=fa830d91b993d15f8a463c8dd68f7106f0dded87928bec36074de934c2c52f73
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_EXTRA_MAKE_ARGS="DESTDIR=${MAGISK_PREFIX}/"
MAGISK_MODULE_MAKE_INSTALL_TARGET="DESTDIR=${MAGISK_PREFIX} install"



magisk_step_make() {
   CFLAGS+=" -static"
   LDFLAGS+=" -static"
   LDFLAGS=$LDFLAGS CFLAGS=$CFLAGS make
   #sudo cp $MAGISK_MODULE_SRCDIR/mdns-scan /system/bin;
}
