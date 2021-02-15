MAGISK_MODULE_HOMEPAGE=https://git-scm.com/
MAGISK_MODULE_DESCRIPTION="Fast, scalable, distributed revision control system"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_MAINTAINER="@termux"
MAGISK_MODULE_VERSION=2.30.1
MAGISK_MODULE_SRCURL=https://www.kernel.org/pub/software/scm/git/git-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=f988a8a095089978dab2932af4edb22b4d7d67d67b81aaa1986fa29ef45d9467
MAGISK_MODULE_DEPENDS="libcurl, libiconv, less, openssl, pcre2, zlib"

## This requires a working $MAGISK_PREFIX/bin/sh on the host building:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+="
ac_cv_fread_reads_directories=yes
ac_cv_header_libintl_h=no
ac_cv_iconv_omits_bom=no
ac_cv_snprintf_returns_bogus=no
--with-openssl=$MAGISK_PREFIX
--with-curl=$MAGISK_PREFIX
--with-shell=$MAGISK_PREFIX/bin/sh
--libexecdir=$MAGISK_PREFIX/usr/libexec
--with-editor=nano
--disable-shared
--with-iconv=$MAGISK_PREFIX
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
MAGISK_MODULE_BUILD_IN_SRC=true

# Things to remove to save space:
#  bin/git-cvsserver - server emulating CVS
#  bin/git-shell - restricted login shell for Git-only SSH access
MAGISK_MODULE_RM_AFTER_INSTALL="
bin/git-cvsserver
bin/git-shell
usr/libexec/git-core/git-shell
usr/libexec/git-core/git-cvsserver
usr/share/man/man1/git-cvsserver.1
usr/share/man/man1/git-shell.1
"

magisk_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $MAGISK_PREFIX.
	#if $MAGISK_ON_DEVICE_BUILD; then
	#	magisk_error_exit "Package '$MAGISK_MODULE_NAME' is not safe for on-device builds."
	#fi

	# Setup perl so that the build process can execute it:
	rm -f $MAGISK_PREFIX/bin/perl
	ln -s $(which perl) $MAGISK_PREFIX/bin/perl

	# Force fresh perl files (otherwise files from earlier builds
	# remains without bumped modification times, so are not picked
	# up by the package):
	rm -Rf $MAGISK_PREFIX/share/git-perl

	export CURL_CONFIG=/system/bin/curl-config
	export OPENSSLDIR=$MAGISK_PREFIX/etc/tls
	export CPPFLAGS="-I$MAGISK_MODULE_SRCDIR $CPPFLAGS -DCURL_STATIC -DCURL_STATICLIB=true -DCARES_STATICLIB=true"
	export LDFLAGS=" $LDFLAGS -L$MAGISK_PREFIX/lib -static"
	export LIBS=" -ldl -lzstd -liconv -lz -lssl -lcrypto -lz -ldl -lnghttp2 -lcares -lcurl"
	#export LIBS=" -ldl -lz -lssl -lcrypto -lcares -lcurl -lnghttp2 -lz"
}


magisk_step_make() {
	make V=2 -j $MAGISK_MAKE_PROCESSES "$MAGISK_MODULE_EXTRA_MAKE_ARGS --static"
	make V=2 -j $MAGISK_MAKE_PROCESSES -C contrib/subtree "$MAGISK_MODULE_EXTRA_MAKE_ARGS --static"
}

mmagisk_step_make_install() {
	make V=2 $MAGISK_MODULE_EXTRA_MAKE_ARGS install
	make V=2 -C contrib/subtree $MAGISK_MODULE_EXTRA_MAKE_ARGS install

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
	(cd $MAGISK_PREFIX/bin; ln -s -f ../usr/libexec/git-core/git git)
	(cd $MAGISK_PREFIX/bin; ln -s -f ../usr/libexec/git-core/git-upload-pack git-upload-pack)
}

magisk_step_post_massage() {
	if [ ! -f usr/libexec/git-core/git-remote-https ]; then
		magisk_error_exit "Git built without https support"
	fi
}
