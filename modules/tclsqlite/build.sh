MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/coreutils
MAGISK_MODULE_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=3.33.0
MAGISK_MODULE_SRCURL=https://github.com/sqlite/sqlite/archive/version-3.33.0.tar.gz
MAGISK_MODULE_SHA256=48e5f989eefe9af0ac758096f82ead0f3c7b58118ac17cc5810495bd5084a331
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--disable-threads
"

mmagisk_step_pre_configure() {
	echo "PreConfiguring";
	LINKER=linker64;
	LARCH=aarch64;
	OSARCH=android-arm64;
	export target_host=aarch64-linux-android;	

	#export CFLAGS=' -static -O3';
	#export LDFLAGS=' -static';

	sed -i 's/#ifdef __linux__/#ifndef __linux__/g' src/ls.c;
	sed -i "s/USE_FORTIFY_LEVEL/BIONIC_FORTIFY/g" lib/cdefs.h;
	sed -i "s/USE_FORTIFY_LEVEL/BIONIC_FORTIFY/g" lib/stdio.in.h;
	sed -i -e '/if (!num && negative)/d' -e "/return minus_zero/d" -e "/DOUBLE minus_zero = -0.0/d" lib/strtod.c;

}

magisk_step_configure() {
	echo "Configuring";

	export target_host=aarch64-linux-android;
	AR=$target_host-ar \
	AS=$target_host-as \
	LD=$target_host-ld \
	RANLIB=$target_host-ranlib \
	STRIP=$target_host-strip \
        CC=$target_host-gcc \
        GCC=$target_host-gcc \
        CXX=$target_host-gcc \
        GXX=$target_host-g++ \
	./configure \
	--prefix=$MAGISK_PREFIX \
	--host=$target_host \
	--with-cc=$target_host-gcc \
	$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS;
	#--target=$target_host \
	#CFLAGS=" -I$MAGISK_PREFIX/include $CFLAGS" \
	#LDFLAGS=" -L$MAGISK_PREFIX/lib $LDFLAGS";

	#[ ! "$(grep '^LDFLAGS += -Wl,--unresolved-symbols=ignore-in-object-files' src/local.mk)" ] && sed -i '1iLDFLAGS += -Wl,--unresolved-symbols=ignore-in-object-files' src/local.mk;
	#[ ! "$(grep '#define HAVE_MKFIFO 1' lib/config.h)" ] && echo "#define HAVE_MKFIFO 1" >> lib/config.h;
}

magisk_step_make(){
	echo "Making";
	export target_host=aarch64-linux-android;
	AR=$target_host-ar \
	AS=$target_host-as \
	LD=$target_host-ld \
	RANLIB=$target_host-ranlib \
	STRIP=$target_host-strip \
        CC=$target_host-gcc \
        GCC=$target_host-gcc \
        GXX=$target_host-g++ \
        CXX=$target_host-gcc \
	make
	make sqlite3.c
	make install;
}
