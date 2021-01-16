MAGISK_MODULE_HOMEPAGE=https://tsl0922.github.io/ttyd/
MAGISK_MODULE_DESCRIPTION="Command-line tool for sharing terminal over the web"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=1.6.1
MAGISK_MODULE_REVISION=3
MAGISK_MODULE_SRCURL=https://github.com/tsl0922/ttyd/archive/$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=d72dcca3dec00cda87b80a0a25ae4fee2f8b9098c1cdb558508dcb14fbb6fafc
MAGISK_MODULE_DEPENDS="libandroid-support, json-c, libuv, libwebsockets, zlib"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_PREFIX=$MAGISK_PREFIX \
-DCMAKE_BUILD_TYPE=RELEASE \
-DCMAKE_XXD=$MAGISK_MODULE_TMPDIR/xxd \
-DLWS_STATIC_PIC=ON
"

magisk_step_pre_configure() {
	magisk_download \
		https://raw.githubusercontent.com/vim/vim/v8.1.0427/src/xxd/xxd.c \
		$MAGISK_MODULE_CACHEDIR/xxd.c \
		021b38e02cd31951a80ef5185271d71f2def727eb8ff65b7a07aecfbd688b8e1
	gcc $MAGISK_MODULE_CACHEDIR/xxd.c -o $MAGISK_MODULE_TMPDIR/xxd
	#export LDFLAGS+=" -lssl -landroid-support -lwebsockets -static"
	#echo $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS
	sed -i '5s;^;\nSET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")\nSET(CMAKE_EXE_LINKER_FLAGS "-L/system/lib -static")\n;' CMakeLists.txt
	cat CMakeLists.txt
}
