
MAGISK_MODULE_HOMEPAGE=https://git-scm.com/
MAGISK_MODULE_DESCRIPTION="Fast, scalable, distributed revision control system"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.22.0
MAGISK_MODULE_SRCURL=https://www.kernel.org/pub/software/scm/git/git-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=159e4b599f8af4612e70b666600a3139541f8bacc18124daf2cbe8d1b934f29f
MAGISK_MODULE_DEPENDS="zlib, pcre2, openssl, less, libcurl, libiconv"

MAGISK_MODULE_EXTRA_MAKE_ARGS="
NO_NSEC=1
NO_GETTEXT=1
NO_EXPAT=1
INSTALL_SYMLINKS=1
USE_LIBPCRE2=1
"

# This requires a working $MAGISK_PREFIX/bin/sh on the host building:
MAGISK_MODULE_BUILD_IN_SRC="yes"

#magisk_step_setup_toolchain() {
#	export STRIP=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-strip
#}

magisk_step_configure() {
	# Setup perl so that the build process can execute it:
	rm -f $MAGISK_PREFIX/bin/perl
	ln -s $(which perl) $MAGISK_PREFIX/bin/perl

	# Force fresh perl files (otherwise files from earlier builds
	# remains without bumped modification times, so are not picked
	# up by the package):
	rm -Rf $MAGISK_PREFIX/share/git-perl

	cd $MAGISK_MODULE_SRCDIR

	#export PATH=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
	#export CC=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android28-clang
	#export LD=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-ld
	#AR=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-ar
	#AS=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-as
	#CXX=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android28-cxx
	#RANLIB=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-ranlib
	#export CPP=/home/builder/lib/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android-cpp
	./configure --prefix=$MAGISK_PREFIX --libexecdir=$MAGISK_PREFIX/usr/libexec --datarootdir=$MAGISK_PREFIX/usr/share --host=aarch64-linux-android --target=aarch64-linux-android --with-curl --with-zlib --with-ssl --libdir=/system/lib --includedir=/system/include  ac_cv_fread_reads_directories=yes ac_cv_header_libintl_h=no ac_cv_snprintf_returns_bogus=no CURL_CONFIG=/system/bin/curl-config
}

magisk_step_make() {
	make -j $(nproc) V=1 $MAGISK_MODULE_EXTRA_MAKE_ARGS CFLAGS+=" -static"
	make -j $(nproc) -C contrib/subtree V=1 $MAGISK_MODULE_EXTRA_MAKE_ARGS CFLAGS+=" -static"
	#LDFLAGS+=" -lcrypto -lssl -lcurl -ldl -lz -liconv -lcharset"
	#LIBS="-ldl -lz -liconv -lcharset"
	# -ldl -lcrypt -lssl -lcurl" EXTLIBS="-ldl -libcrypt -lssl -lcurl -lz -lc"
	#LDFLAGS+="-ldl -lcurl -lnghttp2 -lcrypto -lssl"
	#make -j $(nproc) -C contrib/subtree V=1 $MAGISK_MODULE_EXTRA_MAKE_ARGS LDFLAGS+=" -L/system/lib"
}

magisk_step_make_install() {
	make -j $(nproc) V=1 $MAGISK_MODULE_EXTRA_MAKE_ARGS install CFLAGS+=" -static"
	make -j $(nproc) -C contrib/subtree V=1 $MAGISK_MODULE_EXTRA_MAKE_ARGS install CFLAGS+=" -static"
	#make -j $(nproc) -C contrib/subtree V=1 $MAGISK_MODULE_EXTRA_MAKE_ARGS install LDFLAGS+=" -L/system/lib"
	mkdir -p $MAGISK_PREFIX/etc/bash_completion.d/
	cp $MAGISK_MODULE_SRCDIR/contrib/completion/git-completion.bash $MAGISK_PREFIX/etc/bash_completion.d/
	cp $MAGISK_MODULE_SRCDIR/contrib/completion/git-prompt.sh $MAGISK_PREFIX/etc/bash_completion.d/
}

mmagisk_step_post_make_install() {
	mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin
	fdfind -t x ^git$ $MAGISK_MODULE_SRCDIR --exec cp {}  $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/
	tree $MAGISK_MODULE_SRCDIR
	tree $MAGISK_MODULE_MASSAGEDIR

	# Remove the build machine perl setup in magisk_step_pre_configure to avoid it being packaged:

	# Remove clutter:
	#rm -Rf $MAGISK_PREFIX/lib/*-linux*/perl

	# Remove duplicated binaries in bin/ with symlink to the one in libexec/git-core:
	#(cd $MAGISK_PREFIX/bin; ln -s -f ../libexec/git-core/git git)
	#(cd $MAGISK_PREFIX/bin; ln -s -f ../libexec/git-core/git-upload-pack git-upload-pack)
}

mmagisk_step_post_massage() {
	return
	#rm $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/perl
	#if [ ! -f libexec/git-core/git-remote-https ]; then
	#	magisk_error_exit "Git built without https support"
	#fi
}



