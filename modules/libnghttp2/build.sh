MAGISK_MODULE_HOMEPAGE=https://nghttp2.org/
MAGISK_MODULE_DESCRIPTION="nghttp HTTP 2.0 library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.39.2
MAGISK_MODULE_SRCURL=https://github.com/nghttp2/nghttp2/releases/download/v1.39.2/nghttp2-1.39.2.tar.xz
MAGISK_MODULE_SHA256=a2d216450abd2beaf4e200c168957968e89d602ca4119338b9d7ab059fd4ce8b
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-lib-only
--disable-shared
--enable-static
"
# The tools are not built due to --enable-lib-only:
MAGISK_MODULE_RM_AFTER_INSTALL="share/man/man1 share/nghttp2/fetch-ocsp-response"
