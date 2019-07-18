MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/libiconv/
MAGISK_MODULE_DESCRIPTION="An implementation of iconv()"
MAGISK_MODULE_LICENSE="LGPL-2.0"
MAGISK_MODULE_VERSION=1.16
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=e6a1b1b589654277ee790cce3734f07876ac4ccfaecbee8afa0b649cf529cc04
MAGISK_MODULE_BREAKS="libandroid-support (<= 24)"
MAGISK_MODULE_REPLACES="libandroid-support (<= 24)"
MAGISK_MODULE_DEVMODULE_BREAKS="ndk-sysroot (<< 19b-4)"
MAGISK_MODULE_DEVMODULE_REPLACES="ndk-sysroot (<< 19b-4)"

# Enable extra encodings (such as CP437) needed by some programs:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-shared
--enable-static
--enable-extra-encodings
"
