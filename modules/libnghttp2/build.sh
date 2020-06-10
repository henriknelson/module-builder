MAGISK_MODULE_HOMEPAGE=https://nghttp2.org/
MAGISK_MODULE_DESCRIPTION="nghttp HTTP 2.0 library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.41.0
MAGISK_MODULE_SRCURL=https://github.com/nghttp2/nghttp2/releases/download/v${MAGISK_MODULE_VERSION}/nghttp2-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=abc25b8dc601f5b3fefe084ce50fcbdc63e3385621bee0cbfa7b57f9ec3e67c2
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-lib-only
--disable-shared
--enable-static
"
# The tools are not built due to --enable-lib-only:
MAGISK_MODULE_RM_AFTER_INSTALL="share/man/man1 share/nghttp2/fetch-ocsp-response"
