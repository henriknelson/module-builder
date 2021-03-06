MAGISK_MODULE_HOMEPAGE=https://github.com/open-source-parsers/jsoncpp
MAGISK_MODULE_DESCRIPTION="C++ library for interacting with JSON"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.9.4
MAGISK_MODULE_SRCURL=https://github.com/open-source-parsers/jsoncpp/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=e34a628a8142643b976c7233ef381457efad79468c67cb1ae0b83a33d7493999
MAGISK_MODULE_DEPENDS="libc++"
MAGISK_MODULE_BREAKS="jsoncpp-dev"
MAGISK_MODULE_REPLACES="jsoncpp-dev"

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=OFF
-DJSONCPP_WITH_TESTS=OFF
-DCCACHE_FOUND=OFF
"

mmagisk_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $MAGISK_PREFIX.
	#if $MAGISK_ON_DEVICE_BUILD; then
	#	magisk_error_exit "Package '$MAGISK_MODULE_NAME' is not safe for on-device builds."
	#fi

	# The installation does not overwrite symlinks such as libjsoncpp.so.1,
	# so if rebuilding these are not detected as modified. Fix that:
	rm -f $MAGISK_PREFIX/lib/libjsoncpp.so*
}
