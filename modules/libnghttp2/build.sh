MAGISK_MODULE_HOMEPAGE=https://nghttp2.org/
MAGISK_MODULE_DESCRIPTION="nghttp HTTP 2.0 library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.40.0
MAGISK_MODULE_SRCURL=https://github.com/nghttp2/nghttp2/releases/download/v1.40.0/nghttp2-1.40.0.tar.xz
MAGISK_MODULE_SHA256=09fc43d428ff237138733c737b29fb1a7e49d49de06d2edbed3bc4cdcee69073
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-lib-only
--disable-shared
--enable-static
"
# The tools are not built due to --enable-lib-only:
MAGISK_MODULE_RM_AFTER_INSTALL="share/man/man1 share/nghttp2/fetch-ocsp-response"
