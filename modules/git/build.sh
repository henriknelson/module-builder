MAGISK_MODULE_HOMEPAGE=https://git-scm.com/
MAGISK_MODULE_DESCRIPTION="Fast, scalable, distributed revision control system"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.22.0
MAGISK_MODULE_SRCURL=https://www.kernel.org/pub/software/scm/git/git-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=159e4b599f8af4612e70b666600a3139541f8bacc18124daf2cbe8d1b934f29f
# less is required as a pager for git log, and the busybox less does not handle used escape sequences.
#MAGISK_MODULE_DEPENDS="zlib, pcre2, openssl, less, libcurl, libiconv"

## This requires a working $MAGISK_PREFIX/bin/sh on the host building:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_fread_reads_directories=yes
ac_cv_header_libintl_h=no
ac_cv_snprintf_returns_bogus=no
--with-curl
--without-tcltk
--with-shell=$MAGISK_PREFIX/bin/sh
"
# expat is only used by git-http-push for remote lock management over DAV, so disable:
# NO_INSTALL_HARDLINKS to use symlinks instead of hardlinks (which does not work on Android M):
MAGISK_MODULE_EXTRA_MAKE_ARGS="
NO_NSEC=1
NO_GETTEXT=1
NO_EXPAT=1
NO_INSTALL_HARDLINKS=1
PERL_PATH=$MAGISK_PREFIX/bin/perl
USE_LIBPCRE2=1
"
MAGISK_MODULE_BUILD_IN_SRC="yes"

# Things to remove to save space:
#  bin/git-cvsserver - server emulating CVS
#  bin/git-shell - restricted login shell for Git-only SSH access
MAGISK_MODULE_RM_AFTER_INSTALL="
bin/git-cvsserver
bin/git-shell
libexec/git-core/git-shell
libexec/git-core/git-cvsserver
share/man/man1/git-cvsserver.1
share/man/man1/git-shell.1
"

magisk_step_pre_configure() {
	# Setup perl so that the build process can execute it:
	rm -f $MAGISK_PREFIX/bin/perl
	ln -s $(which perl) $MAGISK_PREFIX/bin/perl

	# Force fresh perl files (otherwise files from earlier builds
	# remains without bumped modification times, so are not picked
	# up by the package):
	rm -Rf $MAGISK_PREFIX/share/git-perl

	# Fixes build if utfcpp is installed:
	CPPFLAGS="-I$MAGISK_MODULE_SRCDIR $CPPFLAGS"
}

magisk_step_make() {
	export PATH=/usr/local/musl/bin:$PATH
	target=aarch64-linux-musl
	export CC=$target-gcc
	export CPP=$target-cpp
	export LD=$target-ld
	export AR=$target-ar
	export AS=$target-as
	export NM=$target-nm
	export STRIP=$target-strip
	export RANLIB=$target-ranlib
	#CC=$CC LD=$LD 
	CC=musl-cc make -j $MAGISK_MAKE_PROCESSES $MAGISK_MODULE_EXTRA_MAKE_ARGS
	make -j $MAGISK_MAKE_PROCESSES -C contrib/subtree $MAGISK_MODULE_EXTRA_MAKE_ARGS
}

magisk_step_make_install() {
	make $MAGISK_MODULE_EXTRA_MAKE_ARGS install
	make -C contrib/subtree $MAGISK_MODULE_EXTRA_MAKE_ARGS install

	# Installing man requires asciidoc and xmlto, so git uses separate make targets for man pages
	make -j $MAGISK_MAKE_PROCESSES install-man
	make -j $MAGISK_MAKE_PROCESSES -C contrib/subtree install-man
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/etc/bash_completion.d/
	cp $MAGISK_MODULE_SRCDIR/contrib/completion/git-completion.bash \
	   $MAGISK_MODULE_SRCDIR/contrib/completion/git-prompt.sh \
	   $MAGISK_PREFIX/etc/bash_completion.d/

	# Remove the build machine perl setup in magisk_step_pre_configure to avoid it being packaged:
	rm $MAGISK_PREFIX/bin/perl

	# Remove clutter:
	rm -Rf $MAGISK_PREFIX/lib/*-linux*/perl

	# Remove duplicated binaries in bin/ with symlink to the one in libexec/git-core:
	(cd $MAGISK_PREFIX/bin; ln -s -f ../libexec/git-core/git git)
	(cd $MAGISK_PREFIX/bin; ln -s -f ../libexec/git-core/git-upload-pack git-upload-pack)
}

magisk_step_post_massage() {
	if [ ! -f libexec/git-core/git-remote-https ]; then
		magisk_error_exit "Git built without https support"
	fi
}
