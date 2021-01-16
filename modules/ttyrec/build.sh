MAGISK_MODULE_HOMEPAGE=http://0xcc.net/ttyrec/
MAGISK_MODULE_DESCRIPTION="Terminal recorder and player"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=1.0.8
MAGISK_MODULE_REVISION=6
MAGISK_MODULE_SRCURL=http://0xcc.net/ttyrec/ttyrec-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=ef5e9bf276b65bb831f9c2554cd8784bd5b4ee65353808f82b7e2aef851587ec
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	#rm -f Makefile release.Makefile
	#export CC_x86_64_unknown_linux_gnu=gcc
	#export CFLAGS_x86_64_unknown_linux_gnu="-O2"
	#export LDFLAGS="$LDFLAGS -lc -static"
	export target_host=aarch64-linux-android;
      	export AR=$target_host-ar;
	export AS=$target_host-as;
	export LD=$target_host-ld;
	export RANLIB=$target_host-ranlib;
	export STRIP=$target_host-strip;
	export CC=$target_host-clang;
	export GCC=$target_host-gcc;
	export CXX=$target_host-clang++;
	export GXX=$target_host-g++;
	export LDFLAGS="$LDFLAGS -lc -ldl -static"
	export CFLAGS="$CFLAGS -static"
	#CFLAGS+=" -Dset_progname=setprogname $LDFLAGS"
}

magisk_step_make() {
	CC=$GCC make
}

magisk_step_make_install() {
	cp ttyrec ttyplay ttytime $MAGISK_PREFIX/bin
	mkdir -p $MAGISK_PREFIX/share/man/man1
	cp ttyrec.1 ttyplay.1 ttytime.1 $MAGISK_PREFIX/share/man/man1
}
