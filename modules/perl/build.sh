MAGISK_MODULE_HOMEPAGE=https://www.perl.org/
MAGISK_MODULE_DESCRIPTION="Capable, feature-rich programming language"
MAGISK_MODULE_LICENSE="Artistic-License-2.0"
MAGISK_MODULE_VERSION=(5.30.2
                    1.3.2)
MAGISK_MODULE_SHA256=(66db7df8a91979eb576fac91743644da878244cf8ee152f02cd6f5cd7a731689
                   defa12f0ad7be0b6c48b4f76e2fb5b37c1b37fbeb6e9ebe938279cd539a0c20c)
MAGISK_MODULE_SRCURL=(http://www.cpan.org/src/5.0/perl-${MAGISK_MODULE_VERSION}.tar.gz
		   https://github.com/arsv/perl-cross/releases/download/${MAGISK_MODULE_VERSION[1]}/perl-cross-${MAGISK_MODULE_VERSION[1]}.tar.gz)
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MAKE_PROCESSES=1

#MAGISK_MODULE_RM_AFTER_INSTALL="bin/perl${MAGISK_MODULE_VERSION}"

magisk_step_post_extract_module() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $MAGISK_PREFIX.
	#if $MAGISK_ON_DEVICE_BUILD; then
	#	MAGISK_error_exit "Package '$MAGISK_MODULE_NAME' is not safe for on-device builds."
	#fi
	#dir=$(pwd);
	#cd $MAGISK_MODULE_SRCDIR
	#make clean
	#cd $dir
	#sudo mkdir
	#sudo chown -R builder:builder /data/perl
	# This port uses perl-cross: http://arsv.github.io/perl-cross/
	cp -rf perl-cross-${MAGISK_MODULE_VERSION[1]}/* .
	sudo chown builder:builder -R $MAGISK_MODULE_SRCDIR;
	sudo chmod 775 -R $MAGISK_MODULE_SRCDIR;
	## Remove old installation to force fresh:
	rm -rf /data/perl/lib/perl5
	rm -f /data/perl/lib/libperl.a
	rm -f /data/perl/include/perl
}

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

	#export LINKTYPE=static
	#export CFLAGS=' -static -O2';
	#export LDFLAGS=' -static';
}

magisk_step_configure() {
	export PATH=$PATH:$MAGISK_STANDALONE_TOOLCHAIN/bin

	ORIG_AR=$AR; unset AR
	ORIG_AS=$AS; unset AS
	ORIG_CC=$CC; unset CC
	ORIG_CXX=$CXX; unset CXX
	ORIG_CPP=$CPP; unset CPP
	ORIG_CFLAGS=$CFLAGS; unset CFLAGS
	ORIG_CPPFLAGS=$CPPFLAGS; unset CPPFLAGS
	ORIG_CXXFLAGS=$CXXFLAGS; unset CXXFLAGS
	ORIG_LDFLAGS=$LDFLAGS; unset LDFLAGS
	ORIG_RANLIB=$RANLIB; unset RANLIB
	ORIG_LD=$LD; unset LD

	rm -f $MAGISK_PREFIX/bin/sh
	ln -s /bin/sh $MAGISK_PREFIX/bin/sh

	#export target_host=aarch64-linux-android;

	cd $MAGISK_MODULE_BUILDDIR
	$MAGISK_MODULE_SRCDIR/configure \
		--target=aarch64-linux-android \
		--targetarch=aarch64-unknown-linux-android \
		-Dosname=android \
		-Darchname=aarch64-android \
		-Dsysroot=$MAGISK_STANDALONE_TOOLCHAIN/sysroot \
		-Dprefix=/data/perl \
		-Dsh=$MAGISK_PREFIX/bin/sh \
		-Dcc="$ORIG_CC -Wl,-rpath=/data/perl/lib:/data/perl/lib/perl5/5.30.2/aarch64-android/CORE -Wl,--enable-new-dtags" \
		-Duseshrplib;
}

#-Ud_sem \
#-Ud_shm \

mmagisk_step_pre_configure() {
	export PATH="$MAGISK_STANDALONE_TOOLCHAIN/bin:$PATH"

	ORIG_AR=$AR; unset AR
	ORIG_AS=$AS; unset AS
	ORIG_CC=$CC; unset CC
	ORIG_CXX=$CXX; unset CXX
	ORIG_CPP=$CPP; unset CPP
	ORIG_CFLAGS=$CFLAGS; unset CFLAGS
	ORIG_CPPFLAGS=$CPPFLAGS; unset CPPFLAGS
	ORIG_CXXFLAGS=$CXXFLAGS; unset CXXFLAGS
	ORIG_LDFLAGS=$LDFLAGS; unset LDFLAGS
	ORIG_RANLIB=$RANLIB; unset RANLIB
	ORIG_LD=$LD; unset LD

	# Since we specify $MAGISK_PREFIX/bin/sh below for the shell
	# it will be run during the build, so temporarily (removed in
	# MAGISK_step_post_make_install below) setup symlink:
	rm -f $MAGISK_PREFIX/bin/sh
	ln -s /bin/sh $MAGISK_PREFIX/bin/sh

	cd $MAGISK_MODULE_BUILDDIR
	$MAGISK_MODULE_SRCDIR/configure \
		--target=$MAGISK_HOST_PLATFORM \
		-Dosname=android \
		-Dusecrosscompile \
		-Dsysroot=$MAGISK_STANDALONE_TOOLCHAIN/sysroot \
		-Dprefix=$MAGISK_PREFIX \
		-Dsh=$MAGISK_PREFIX/bin/sh \
		-Dcc="$ORIG_CC -Wl,-rpath=\"$MAGISK_PREFIX/lib:/system/lib/perl5/5.30.2/aarch64-android/CORE\" -Wl,--enable-new-dtags" \
		-Duseshrplib;
}

magisk_step_post_make_install() {
	# Replace hardlinks with symlinks:
	#cd $MAGISK_PREFIX/share/man/man1
	#rm perlbug.1
	#ln -s perlthanks.1 perlbug.1

	mkdir -p $MAGISK_PREFIX/data
	cp -r /data/perl $MAGISK_PREFIX/data/

	# Cleanup:
	rm $MAGISK_PREFIX/bin/sh

	cd $MAGISK_PREFIX/data/perl/lib
	ln -f -s perl5/5.30.2/aarch64-android/CORE/libperl.so libperl.so

	mkdir -p $MAGISK_PREFIX/data/perl/include
	cd $MAGISK_PREFIX/data/perl/include
	ln -f -s $MAGISK_PREFIX/data/perl/lib/perl5/5.30.2/aarch64-android/CORE perl
	#tree /data/perl/lib/perl5/5.30.2/
	#fdfind -IH Config_heavy.pl $MAGISK_MODULE_SRCDIR/..
	cd $MAGISK_MODULE_SRCDIR/lib
	chmod +w Config_heavy.pl
	sed 's',"--sysroot=$MAGISK_STANDALONE_TOOLCHAIN"/sysroot,"-I${MAGISK_PREFIX}/include",'g' Config_heavy.pl > Config_heavy.pl.new
        sed 's',"$MAGISK_STANDALONE_TOOLCHAIN"/sysroot,"-I${MAGISK_PREFIX%%/usr}",'g' Config_heavy.pl.new > Config_heavy.pl
	rm Config_heavy.pl.new
	sudo cp Config_heavy.pl $MAGISK_PREFIX/data/perl/lib/perl5/5.30.2/aarch64-android
	sudo chown -R 0:0 $MAGISK_PREFIX/data/perl/lib
	sudo chmod -R 755 $MAGISK_PREFIX/data/perl/lib
}

mmagisk_step_make(){
	echo "Making";
	make install;
}
