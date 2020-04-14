MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/coreutils/
MAGISK_MODULE_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=8.32
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/coreutils/coreutils-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=4458d8de7849df44ccab15e16b1548b285224dbba5f08fac070c1c0e0bcc4cfa
MAGISK_MODULE_DEPENDS="libandroid-support, libgmp, libiconv, openssl"
MAGISK_MODULE_BREAKS="chroot, busybox (<< 1.30.1-4)"
MAGISK_MODULE_REPLACES="chroot, busybox (<< 1.30.1-4)"
MAGISK_MODULE_ESSENTIAL=true
MAGISK_MODULE_BUILD_IN_SRC=true
# pinky has no usage on Android.
# df does not work either, let system binary prevail.
# $PREFIX/bin/env is provided by busybox for shebangs to work directly.
# users and who doesn't work and does not make much sense for Termux.
# uptime is provided by procps.
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
gl_cv_host_operating_system=Android
ac_cv_func_getpass=yes
--enable-static
--disable-shared
--enable-single-binary=symlinks
--enable-single-binary-exceptions=sort,timeout
"
#MMT="
#gl_cv_host_operating_system=Android
#gl_cv_func_working_mktime=yes
#ac_cv_func_getpass=yes
#--enable-static
#--disable-nls
#--disable-shared
#--disable-xattr
#--enable-no-install-program=pinky,df,users,who,uptime,ls,stat,date
#--enable-single-binary=symlinks
#--without-gmp
#--prefix=$MAGISK_PREFIX
#--with-static
#--without-shared
#"

magisk_step_pre_configure() {
	echo "PreConfiguring";
	LINKER=linker64;
	LARCH=aarch64;
	OSARCH=android-arm64;
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

	export CFLAGS=' -static -O3';
	export LDFLAGS=' -static';

	sed -i 's/#ifdef __linux__/#ifndef __linux__/g' src/ls.c;
	sed -i "s/USE_FORTIFY_LEVEL/BIONIC_FORTIFY/g" lib/cdefs.h;
	sed -i "s/USE_FORTIFY_LEVEL/BIONIC_FORTIFY/g" lib/stdio.in.h;
	sed -i -e '/if (!num && negative)/d' -e "/return minus_zero/d" -e "/DOUBLE minus_zero = -0.0/d" lib/strtod.c;

}

magisk_step_configure() {
	echo "Configuring";
	./configure $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS \
	--prefix=$MAGISK_PREFIX \
	--disable-nls \
	--with-openssl=yes \
	--with-linux-crypto \
	--enable-no-install-program=stdbuf \
	--host=$target_host \
	--target=$target_host \
	CFLAGS=" -I$MAGISK_PREFIX/include $CFLAGS" \
	LDFLAGS=" -L$MAGISK_PREFIX/lib $LDFLAGS";

	#[ ! "$(grep '^LDFLAGS += -Wl,--unresolved-symbols=ignore-in-object-files' src/local.mk)" ] && sed -i '1iLDFLAGS += -Wl,--unresolved-symbols=ignore-in-object-files' src/local.mk;
	#[ ! "$(grep '#define HAVE_MKFIFO 1' lib/config.h)" ] && echo "#define HAVE_MKFIFO 1" >> lib/config.h;
}

mmagisk_step_make(){
	echo "Making";
	make install;
}
