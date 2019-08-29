MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/coreutils/
MAGISK_MODULE_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=8.31
MAGISK_MODULE_REVISION=7
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/coreutils/coreutils-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=ff7a9c918edce6b4f4b2725e3f9b37b0c4d193531cac49a48b56c4d0d3a9e9fd
MAGISK_MODULE_DEPENDS="libandroid-support, libiconv"
MAGISK_MODULE_BREAKS="busybox (<< 1.30.1-4)"
MAGISK_MODULE_REPLACES="busybox (<< 1.30.1-4)"
MAGISK_MODULE_ESSENTIAL=true

# pinky has no usage on Android.
# df does not work either, let system binary prevail.
# $PREFIX/bin/env is provided by busybox for shebangs to work directly.
# users and who doesn't work and does not make much sense for Termux.
# uptime is provided by procps.
MMAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
gl_cv_host_operating_system=Android
ac_cv_func_getpass=yes
--host=aarch64-linux-musl
--target=aarch64-linux-musl
--enable-static
--disable-shared
--disable-xattr
--enable-no-install-program=pinky,df,chroot,users,who,uptime
--enable-single-binary=symlinks
--without-gmp
--with-static
--without-shared
--prefix=$MAGISK_PREFIX
--mandir=$MAGISK_PREFIX/usr/share
"

mmagisk_step_pre_configure() {
	MUSL_PATH=/usr/local/musl/bin
	export CC="$MUSL_PATH/aarch64-linux-musl-cc"
	export AR="$MUSL_PATH/aarch64-linux-musl-ar"
	export LD="$MUSL_PATH/aarch64-linux-musl-ld"
	export CPP="$MUSL_PATH/aarch64-linux-musl-cpp"
	export RANLIB="$MUSL_PATH/aarch64-linux-musl-ranlib"
	#CFLAGS+=" -static"
	#CPPFLAGS+=" -DDEFAULT_TMPDIR=\\\"$MAGISK_PREFIX/tmp\\\""
	#CPPFLAGS+=" -D__USE_FORTIFY_LEVEL=0"
	#LDFLAGS+=" --static"
	# On device build is unsupported as it removes utility 'ln' (and maybe
	# something else) in the installation process.
	#if $MAGISK_ON_DEVICE_BUILD; then
	#	magisk_error_exit "Package '$MAGISK_MODULE_NAME' is not safe for on-device builds."
	#fi
}
MMAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-gold --enable-plugins --disable-werror --with-system-zlib --enable-new-dtags"
MAGISK_MODULE_EXTRA_MAKE_ARGS="tooldir=$MAGISK_PREFIX"
MMAGISK_MODULE_RM_AFTER_INSTALL="share/man/man1/windmc.1 share/man/man1/windres.1 bin/ld.bfd"
MAGISK_MODULE_KEEP_STATIC_LIBRARIES=true
MAGISK_MODULE_BUILD_IN_SRC=true

# Avoid linking against libfl.so from flex if available:
export LEXLIB=

mmagisk_step_pre_configure() {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"
	export LDFLAGs="$LDFLAGS --static"
	export PREF=aarch64-linux-android
	#/usr/local/musl/aarch64-linux-musl
	if [ $MAGISK_ARCH_BITS = 32 ]; then
		export LIB_PATH="${PREF}/lib:/system/lib"
	else
		export LIB_PATH="${PREF}/lib:/system/lib64"
	fi
}

magisk_step_configure() {
	export PATH=/usr/local/musl/bin:$PATH
	PRE=/usr/local/musl/bin/aarch64-linux-musl
	STRIP=$PRE-strip CC=$PRE-gcc CXX=$PRE-c++ LD=$PRE-ld AR=$PRE-ar AS=$PRE-as LIB_PATH="/usr/local/musl/aarch64-linux-musl/lib" ./configure --host aarch64-linux-musl -with-lib-path=/usr/local/musl/aarch64-linux-musl/lib --host=aarch64-linux-musl --target=aarch64-linux-musl --disable-nls --disable-shared
}

magisk_step_make() {
	export PATH=/usr/local/musl/bin:$PATH
	PRE=/usr/local/musl/bin/aarch64-linux-musl
	make CC=$PRE-gcc CXX=$PRE-c++ LD=$PRE-ld AR=$PRE-ar AS=$PRE-as LIB_PATH="/usr/local/musl/lib" CFLAGS+="-I/usr/local/musl/aarch64-linux-musl/include -static" LDFLAGS+="-L/usr/local/musl/aarch64-linux-musl/lib  --static"
}

mmagisk_step_post_make_install() {
	cp $MAGISK_MODULE_BUILDER_DIR/ldd $MAGISK_PREFIX/bin/ldd
	cd $MAGISK_PREFIX/bin
	# Setup symlinks as these are used when building, so used by
	# system setup in e.g. python, perl and libtool:
	for b in ar ld nm objdump ranlib readelf strip; do
		ln -s -f $b $MAGISK_HOST_PLATFORM-$b
	done
	ln -sf ld.gold gold
}
