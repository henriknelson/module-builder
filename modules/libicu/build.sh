MAGISK_MODULE_HOMEPAGE=http://site.icu-project.org/home
MAGISK_MODULE_DESCRIPTION='International Components for Unicode library'
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=66.1
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SRCURL=https://github.com/unicode-org/icu/releases/download/release-${MAGISK_MODULE_VERSION//./-}/icu4c-${MAGISK_MODULE_VERSION//./_}-src.tgz
MAGISK_MODULE_SHA256=52a3f2209ab95559c1cf0a14f24338001f389615bf00e2585ef3dbc43ecf0a2e
MAGISK_MODULE_DEPENDS="libc++"
MAGISK_MODULE_BREAKS="libicu-dev"
MAGISK_MODULE_REPLACES="libicu-dev"
MAGISK_MODULE_HOSTBUILD=true
MAGISK_MODULE_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-samples --disable-tests"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--disable-samples --disable-tests --with-cross-build=$MAGISK_MODULE_HOSTBUILD_DIR"

magisk_step_post_extract_module() {
	MAGISK_MODULE_SRCDIR+="/source"
}
