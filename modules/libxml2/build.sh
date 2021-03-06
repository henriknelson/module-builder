MAGISK_MODULE_HOMEPAGE=http://www.xmlsoft.org
MAGISK_MODULE_DESCRIPTION="Library for parsing XML documents"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=2.9.10
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SRCURL=ftp://xmlsoft.org/libxml2/libxml2-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=aafee193ffb8fe0c82d4afef6ef91972cbaf5feea100edc2f262750611b4be1f
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS=" --without-python --disable-shared"
MAGISK_MODULE_RM_AFTER_INSTALL="share/gtk-doc"
MAGISK_MODULE_DEPENDS="libiconv, liblzma, zlib"
MAGISK_MODULE_BREAKS="libxml2-dev"
MAGISK_MODULE_REPLACES="libxml2-dev"
