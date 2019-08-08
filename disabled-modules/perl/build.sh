MAGISK_MODULE_HOMEPAGE=https://www.perl.org/
MAGISK_MODULE_DESCRIPTION="Capable, feature-rich programming language"
MAGISK_MODULE_LICENSE="Artistic-License-2.0"
MAGISK_MODULE_VERSION=(5.30.0
                    1.3)
MAGISK_MODULE_SHA256=(851213c754d98ccff042caa40ba7a796b2cee88c5325f121be5cbb61bbf975f2
                   49edea1ea2cd6c5c47386ca71beda8d150c748835781354dbe7f75b1df27e703)
MAGISK_MODULE_SRCURL=(http://www.cpan.org/src/5.0/perl-${MAGISK_MODULE_VERSION}.tar.gz
		   https://github.com/arsv/perl-cross/releases/download/${MAGISK_MODULE_VERSION[1]}/perl-cross-${MAGISK_MODULE_VERSION[1]}.tar.gz)
MAGISK_MODULE_BUILD_IN_SRC="yes"
MAGISK_MAKE_PROCESSES=1
MAGISK_MODULE_RM_AFTER_INSTALL="bin/perl${MAGISK_MODULE_VERSION}"
MAGISK_MODULE_NO_DEVELSPLIT=yes

magisk_step_post_extract_module() {
	# This port uses perl-cross: http://arsv.github.io/perl-cross/
	cp -rf perl-cross-${MAGISK_MODULE_VERSION[1]}/* .

	# Remove old installation to force fresh:
	rm -rf $MAGISK_PREFIX/lib/perl5
	rm -f $MAGISK_PREFIX/lib/libperl.so
	rm -f $MAGISK_PREFIX/include/perl
}

magisk_step_configure() {
	#export PATH=$PATH:$MAGISK_STANDALONE_TOOLCHAIN/bin

	#ORIG_AR=$AR; unset AR
	#ORIG_AS=$AS; unset AS
	#ORIG_CC=$CC; unset CC
	#ORIG_CXX=$CXX; unset CXX
	#$ORIG_CPP=$CPP; unset CPP
	#$ORIG_CFLAGS=$CFLAGS; unset CFLAGS
	#$ORIG_CPPFLAGS=$CPPFLAGS; unset CPPFLAGS
	#$ORIG_CXXFLAGS=$CXXFLAGS; unset CXXFLAGS
	#$ORIG_LDFLAGS=$LDFLAGS; unset LDFLAGS
	#ORIG_RANLIB=$RANLIB; unset RANLIB
	#ORIG_LD=$LD; unset LD

	# Since we specify $MAGISK_PREFIX/bin/sh below for the shell
	# it will be run during the build, so temporarily (removed in
	# magisk_step_post_make_install below) setup symlink:
	#rm -f $MAGISK_PREFIX/bin/sh
	#ln -s /bin/sh $MAGISK_PREFIX/bin/sh

	#cd $MAGISK_MODULE_BUILDDIR
	$MAGISK_MODULE_SRCDIR/configure \
		--target=aarch64-linux-android \
		--host=aarch64-linux-android \
		--all-static \
		--with-libs=log,m,rt\
		--host-libs=m,rt \
		-Dusecrosscompile \
		-Dosname=android \
		-Dsysroot=$MAGISK_STANDALONE_TOOLCHAIN/sysroot \
		-Dprefix=$MAGISK_PREFIX \
		-Dincpth=$MAGISK_PREFIX/include \
		-Dlibpth=$MAGISK_PREFIX/lib \
		-Dsh=$MAGISK_PREFIX/bin/sh \
		-Dcc="$CC -Wl,-rpath=$MAGISK_PREFIX/lib -Wl,--enable-new-dtags -Wl,--static" \
		-Duseshrplib
}

magisk_step_make() {
   make clean
   make miniperl
}

magisk_step_post_make_install() {
	# Replace hardlinks with symlinks:
	cd $MAGISK_PREFIX/share/man/man1
	rm perlbug.1
	ln -s perlthanks.1 perlbug.1

	# Cleanup:
	rm $MAGISK_PREFIX/bin/sh

	cd $MAGISK_PREFIX/lib
	ln -f -s perl5/${MAGISK_MODULE_VERSION}/${MAGISK_ARCH}-android/CORE/libperl.so libperl.so

	cd $MAGISK_PREFIX/include
	ln -f -s ../lib/perl5/${MAGISK_MODULE_VERSION}/${MAGISK_ARCH}-android/CORE perl
	cd ../lib/perl5/${MAGISK_MODULE_VERSION}/${MAGISK_ARCH}-android/
	chmod +w Config_heavy.pl
	sed 's',"--sysroot=$MAGISK_STANDALONE_TOOLCHAIN"/sysroot,"-I/data/data/com.magisk/files/usr/include",'g' Config_heavy.pl > Config_heavy.pl.new
	sed 's',"$MAGISK_STANDALONE_TOOLCHAIN"/sysroot,"-I/data/data/com.magisk/files",'g' Config_heavy.pl.new > Config_heavy.pl
	rm Config_heavy.pl.new
}
