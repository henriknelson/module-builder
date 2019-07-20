MAGISK_MODULE_HOMEPAGE=https://www.rarlab.com/
MAGISK_MODULE_DESCRIPTION="Tool for extracting files from .rar archives"
MAGISK_MODULE_LICENSE="non-free"
MAGISK_MODULE_LICENSE_FILE="license.txt"
MAGISK_MODULE_VERSION=5.7.5
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://www.rarlab.com/rar/unrarsrc-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=e1c2fddaa87a88b1535bfc10ca484f3c5af4e5a55fbb933f8819e26203bbe2ee
#MAGISK_MODULE_DEPENDS="libandroid-support, libc++"
MAGISK_MODULE_BUILD_IN_SRC=yes

# Starting with version 7.62 curl started enabling http/2 by default.
# Support for http/2 as added in version 1.4.8-8 of the apt package, so we
# conflict with previous versions to avoid broken installations.
#MAGISK_MODULE_CONFLICTS="apt (<< 1.4.8-8)"

#magisk_step_configure() {
#	./configure --prefix $MAGISK_PREFIX --host=aarch64-linux-android --target=aarch64-linux-android --includedir=/system/include --libdir=/system/lib --disable-shared --with-pic
#}


#magisk_step_pre_configure() {
#	export PATH=/usr/local/musl/bin:$PATH
#	#export CROSS_COMPILE=aarch64-linux-musl
#        export CC=/usr/local/musl/bin/aarch64-linux-musl-gcc
#	#export CPP=/usr/local/musl/bin/aarch64-linux-musl-cpp
#        #export LD=/usr/local/musl/bin/aarch64-linux-musl-ld
#        #LDFLAGS+="${LDFLAGS} --static"
#}

#magisk_step_make_install() {
#        $CC -I/system/include -I$MAGISK_MODULE_SRCDIR/src $CFLAGS $CPPFLAGS $LDFLAGS -Wall -Wextra -fPIC -shared $MAGISK_MODULE_SRCDIR/src/*.c -lcurl -o $MAGISK_PREFIX/lib/libcurl.so
#        mkdir -p $MAGISK_PREFIX/include/
#        cp $MAGISK_MODULE_BUILDER_DIR/*.h $MAGISK_PREFIX/include/
#}

#mmagisk_step_configure() {
#	#export CPPFLAGS=" -I$MAGISK_PREFIX/include"
#	#export LDFLAGS="-static -L$MAGISK_PREFIX/lib"
#	./configure --prefix=$MAGISK_PREFIX --enable-cross-compile --with-zlib --host=aarch64-linux-android --target=aarch64-linux-android --disable-ldap --disable-ldaps --enable-versioned-symbols --enable-threaded-resolver $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS
#	#LIBS+=" -lpthread -ldl"
#}

magisk_step_make() {
	make V=1 LDFLAGS=" --static -ldl" -j$(nproc) -f makefile CXX=$CXX
}

magisk_step_make_install() {
	install -v -m755 unrar $MAGISK_PREFIX/bin
}

