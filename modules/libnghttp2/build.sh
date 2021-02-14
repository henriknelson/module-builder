MAGISK_MODULE_HOMEPAGE=https://nghttp2.org/
MAGISK_MODULE_DESCRIPTION="nghttp HTTP 2.0 library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.43.0
MAGISK_MODULE_SRCURL=https://github.com/nghttp2/nghttp2/releases/download/v${MAGISK_MODULE_VERSION}/nghttp2-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=f7d54fa6f8aed29f695ca44612136fa2359013547394d5dffeffca9e01a26b0f
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-lib-only
--disable-shared
--enable-static
"

# The tools are not built due to --enable-lib-only:
MAGISK_MODULE_RM_AFTER_INSTALL="share/man/man1 share/nghttp2/fetch-ocsp-response"
