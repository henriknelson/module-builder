MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/bash/
MAGISK_MODULE_DESCRIPTION="A sh-compatible shell that incorporates useful features from the Korn shell (ksh) and C shell (csh)"
MAGISK_MODULE_LICENSE="GPL-3.0"
_MAIN_VERSION=5.1
_PATCH_VERSION=4
MAGISK_MODULE_VERSION=${_MAIN_VERSION}.${_PATCH_VERSION}
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}.tar.gz
MAGISK_MODULE_SHA256=cc012bc860406dcf42f64431bcd3d2fa7560c02915a601aba9cd597a39329baa
MAGISK_MODULE_DEPENDS="libandroid-support, libiconv, ncurses, readline (>= 8.0), command-not-found"
MAGISK_MODULE_BREAKS="bash-dev"
MAGISK_MODULE_REPLACES="bash-dev"
MAGISK_MODULE_ESSENTIAL=true
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--host=aarch64-linux-android --enable-multibyte --without-bash-malloc --with-installed-readline --enable-static-link"
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

MAGISK_MODULE_RM_AFTER_INSTALL="usr/share/man/man1/bashbug.1 bin/bashbug"

magisk_step_pre_configure() {
	declare -A PATCH_CHECKSUMS
	PATCH_CHECKSUMS[001]=ebb07b3dbadd98598f078125d0ae0d699295978a5cdaef6282fe19adef45b5fa
	PATCH_CHECKSUMS[002]=15ea6121a801e48e658ceee712ea9b88d4ded022046a6147550790caf04f5dbe
	PATCH_CHECKSUMS[003]=22f2cc262f056b22966281babf4b0a2f84cb7dd2223422e5dcd013c3dcbab6b1
	PATCH_CHECKSUMS[004]=9aaeb65664ef0d28c0067e47ba5652b518298b3b92d33327d84b98b28d873c86

	for PATCH_NUM in $(seq -f '%03g' ${_PATCH_VERSION}); do
		PATCHFILE=$MAGISK_MODULE_CACHEDIR/bash_patch_${PATCH_NUM}.patch
		magisk_download \
			"https://mirrors.kernel.org/gnu/bash/bash-${_MAIN_VERSION}-patches/bash${_MAIN_VERSION/./}-$PATCH_NUM" \
			$PATCHFILE \
			${PATCH_CHECKSUMS[$PATCH_NUM]}
		patch -p0 -i $PATCHFILE
	done
	unset PATCH_CHECKSUMS PATCHFILE PATCH_NUM
}

magisk_step_post_make_install() {
	sed -e "s|@MAGISK_PREFIX@|$MAGISK_PREFIX|" \
		-e "s|@MAGISK_HOME@|$MAGISK_ANDROID_HOME|" \
		$MAGISK_MODULE_BUILDER_DIR/etc-profile > $MAGISK_PREFIX/etc/profile

	# /etc/bash.bashrc - System-wide .bashrc file for interactive shells. (config-top.h in bash source, patched to enable):
	sed -e "s|@MAGISK_PREFIX@|$MAGISK_PREFIX|" \
		-e "s|@MAGISK_HOME@|$MAGISK_ANDROID_HOME|" \
		$MAGISK_MODULE_BUILDER_DIR/etc-bash.bashrc > $MAGISK_PREFIX/etc/bash.bashrc
}
