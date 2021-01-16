MAGISK_MODULE_HOMEPAGE=https://libevent.org/
MAGISK_MODULE_DESCRIPTION="Library that provides asynchronous event notification"
MAGISK_MODULE_LICENSE="BSD 3-Clause"
MAGISK_MODULE_VERSION=2.1.12
MAGISK_MODULE_SRCURL=https://github.com/libevent/libevent/archive/release-${MAGISK_MODULE_VERSION}-stable.tar.gz
MAGISK_MODULE_SHA256=7180a979aaa7000e1264da484f712d403fcf7679b1e9212c4e3d09f5c93efc24
MAGISK_MODULE_BREAKS="libevent-dev"
MAGISK_MODULE_REPLACES="libevent-dev"
MAGISK_MODULE_RM_AFTER_INSTALL="bin/event_rpcgen.py"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
-DEVENT__LIBRARY_TYPE="STATIC" \
-DEVENT__BUILD_SHARED_LIBRARIES=OFF \
-DEVENT__DISABLE_BENCHMARK=ON \
-DEVENT__DISABLE_OPENSSL=ON \
-DEVENT__DISABLE_REGRESS=ON \
-DEVENT__DISABLE_SAMPLES=ON \
-DEVENT__DISABLE_TESTS=ON \
-DEVENT__DISABLE_TESTS=ON \
-DEVENT__HAVE_WAITPID_WITH_WNOWAIT=ON \
-DEVENT__SIZEOF_PTHREAD_T=$((MAGISK_ARCH_BITS/8)) \
"
#MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_pre_configure() {
	LDFLAGS=" -static"
}

mmagisk_step_configure() {
	./autogen.sh
	
}
