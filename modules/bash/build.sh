MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/bash/
MAGISK_MODULE_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_DEPENDS="ncurses, readline (>= 8.0), libandroid-support"
_MAIN_VERSION=5.0
_PATCH_VERSION=7
MAGISK_MODULE_SHA256=b4a80f2ac66170b2913efbfb9f2594f1f76c7b1afd11f799e22035d63077fb4d
MAGISK_MODULE_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}.tar.gz
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--enable-multibyte --without-bash-malloc --with-installed-readline"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" bash_cv_job_control_missing=present"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" bash_cv_sys_siglist=yes"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" bash_cv_func_sigsetjmp=present"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" bash_cv_unusable_rtsigs=no"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_mbsnrtowcs=no"
# Use bash_cv_dev_fd=whacky to use /proc/self/fd instead of /dev/fd.
# After making this change process substitution such as in 'cat <(ls)' works.
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" bash_cv_dev_fd=whacky"
# Bash assumes that getcwd is broken and provides a wrapper which
# does not work when not all parent directories up to root are
# accessible, which they are not under Android (/data). See
# - http://permalink.gmane.org/gmane.linux.embedded.yocto.general/25204
# - https://github.com/termux/termux-app/issues/200
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" bash_cv_getcwd_malloc=yes"

MAGISK_MODULE_CONFFILES="etc/bash.bashrc etc/profile"

MAGISK_MODULE_RM_AFTER_INSTALL="share/* bin/bashbug"

magisk_step_configure() {
	target_host=aarch64-linux-gnu
	$MAGISK_MODULE_SRCDIR/configure \
		--host=$target_host \
		--prefix=$MAGISK_PREFIX \
		--datarootdir=$MAGISK_MODULE_TMPDIR \
		--disable-nls \
		--enable-static-link  \
		--without-bash-malloc \
		bash_cv_dev_fd=whacky \
		bash_cv_getcwd_malloc=yes \
		--enable-largefile \
		--enable-alias \
		--enable-history \
		--enable-readline \
		--enable-multibyte \
		--enable-job-control \
		--enable-array-variables \
		CFLAGS="-g -O2" \
		LDFLAGS="-g -O2"
}


magisk_step_patch_module() {
	PVER=$(echo $_MAIN_VERSION | sed 's/\.//')

  	echo "Applying online patches.."
	for i in {001..015}; do
    		if wget -q "http://mirrors.kernel.org/gnu/bash/bash-$_MAIN_VERSION-patches/bash$PVER-$i" > /dev/null; then
			echo "Patching bash$PVER-$i"
			patch -p0 -i bash$PVER-$i
			rm -f bash$PVER-$i
		else
			continue
		fi
	done

	echo "\n\n"

	echo "Applying local patches.."
	for i in $MAGISK_MODULE_BUILDER_DIR/*.patch ; do
    		PFILE=$(basename $i)
		echo "Patching $PFILE"
		cp -f $i $PFILE
		patch -p0 -i $PFILE
		[ $? -ne 0 ] && { echo "Patching failed! Did you verify line numbers? See README for more info"; exit 1; }
		rm -f $PFILE
  	done
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin
	ls $MAGISK_MODULE_SRCDIR
	cp $MAGISK_MODULE_SRCDIR/bash $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/bash
	rm -Rf $MAGISK_MODULE_MASSAGEDIR/bin
	tree $MAGISK_MODULE_MASSAGEDIR
}
