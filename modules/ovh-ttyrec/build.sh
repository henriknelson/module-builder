MAGISK_MODULE_HOMEPAGE=http://0xcc.net/ttyrec/
MAGISK_MODULE_DESCRIPTION="Terminal recorder and player"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.1.6.5
MAGISK_MODULE_SRCURL=https://github.com/ovh/ovh-ttyrec/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=2c7b590341a7410aca36aebe39b3fd775c4b6e0c0fc9be2280ceed11279f5cff
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--prefix=$MAGISK_PREFIX"

magisk_step_configure() {
	#rm -f Makefile release.Makefile
	#CC_x86_64_unknown_linux_gnu=gcc
	#CFLAGS_x86_64_unknown_linux_gnu="-O2"
	#LDFLAGS="$LDFLAGS -lc -static"
	export target_host=aarch64-linux-android;
      	AR=$target_host-ar \
	AS=$target_host-as \
	LD=$target_host-ld \
	RANLIB=$target_host-ranlib \
	STRIP=$target_host-strip \
	CC=$target_host-clang \
	GCC=$target_host-gcc \
	CXX=$target_host-clang++ \
	GXX=$target_host-g++ \
	LDFLAGS="$LDFLAGS -lc -ldl -static" \
	CFLAGS="$CFLAGS -static" \
	./configure --prefix=$MAGISK_PREFIX;
	#CFLAGS+=" -Dset_progname=setprogname $LDFLAGS"
}

magisk_step_make() {
	GCC=$target_host-gcc CFLAGS=" -static" make
}

magisk_step_make_install() {
	cp ttyrec ttyplay ttytime $MAGISK_PREFIX/bin
	mkdir -p $MAGISK_PREFIX/share/man/man1
	#cp ttyrec.1 ttyplay.1 ttytime.1 $MAGISK_PREFIX/share/man/man1
}
