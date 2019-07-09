MAGISK_MODULE_HOMEPAGE=https://curl.haxx.se/
MAGISK_MODULE_DESCRIPTION="Easy-to-use client-side URL transfer library"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=7.65.1
MAGISK_MODULE_SRCURL=https://curl.haxx.se/download/curl-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=cbd36df60c49e461011b4f3064cff1184bdc9969a55e9608bf5cadec4686e3f7
MAGISK_MODULE_DEPENDS="openssl (>= 1.1.1), libnghttp2, zlib"

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-ntlm-wb=$MAGISK_PREFIX/bin/ntlm_auth
--with-ca-bundle=$MAGISK_PREFIX/etc/tls/cert.pem
--with-nghttp2
--without-libidn
--without-libidn2
--without-librtmp
--without-brotli
--with-ssl
"

MAGISK_MODULE_INCLUDE_IN_DEVMODULE="bin/curl-config share/man/man1/curl-config.1"

# Starting with version 7.62 curl started enabling http/2 by default.
# Support for http/2 as added in version 1.4.8-8 of the apt package, so we
# conflict with previous versions to avoid broken installations.
MAGISK_MODULE_CONFLICTS="apt (<< 1.4.8-8)"
