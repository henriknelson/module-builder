magisk_step_configure_autotools() {
	if [ ! -e "$MAGISK_MODULE_SRCDIR/configure" ]; then return; fi

	local ENABLE_STATIC="--enable-static"
	if [ "$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS" != "${MAGISK_MODULE_EXTRA_CONFIGURE_ARGS/--disable-static/}" ]; then
		ENABLE_STATIC=""
	fi

	local DISABLE_NLS="--disable-nls"
	if [ "$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS" != "${MAGISK_MODULE_EXTRA_CONFIGURE_ARGS/--enable-nls/}" ]; then
		DISABLE_NLS=""
	fi

	local DISABLE_SHARED="--disable-shared"
	if [ "$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS" != "${MAGISK_MODULE_EXTRA_CONFIGURE_ARGS/--enable-shared/}" ]; then
		DISABLE_SHARED=""
	fi

	local ENABLE_DATAROOT="--datarootdir=$MAGISK_PREFIX/usr/share"
	if [ "$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS" != "${MAGISK_MODULE_EXTRA_CONFIGURE_ARGS/--disable-dataroot/}" ]; then
		ENABLE_DATAROOT=""
	fi

	local HOST_FLAG="--host=$MAGISK_HOST_PLATFORM"
	if [ "$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS" != "${MAGISK_MODULE_EXTRA_CONFIGURE_ARGS/--host=/}" ]; then
		HOST_FLAG=""
	fi

	local LIBEXEC_FLAG="--libexecdir=$MAGISK_PREFIX/libexec"
	if [ "$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS" != "${MAGISK_MODULE_EXTRA_CONFIGURE_ARGS/--libexecdir=/}" ]; then
		LIBEXEC_FLAG=""
	fi

	local QUIET_BUILD=
	if [ $MAGISK_QUIET_BUILD = true ]; then
		QUIET_BUILD="--enable-silent-rules --silent --quiet"
	fi

	local VERBOSE_BUILD="--enable-verbose"
	if [ "$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS" != "${MAGISK_MODULE_EXTRA_CONFIGURE_ARGS/--disable--verbose/}" ]; then
		VERBOSE_BUILD="--disable-verbose"
	fi

	# Some modules provides a $MODULE-config script which some configure scripts pickup instead of pkg-config:
	mkdir "$MAGISK_MODULE_TMPDIR/config-scripts"
	for f in $MAGISK_PREFIX/bin/*config; do
		test -f "$f" && cp "$f" "$MAGISK_MODULE_TMPDIR/config-scripts"
	done
	export PATH=$MAGISK_MODULE_TMPDIR/config-scripts:$PATH

	# Avoid gnulib wrapping of functions when cross compiling. See
	# http://wiki.osdev.org/Cross-Porting_Software#Gnulib
	# https://gitlab.com/sortix/sortix/wikis/Gnulib
	# https://github.com/termux/termux-packages/issues/76
	local AVOID_GNULIB=""
	AVOID_GNULIB+=" ac_cv_func_nl_langinfo=yes"
	AVOID_GNULIB+=" ac_cv_func_calloc_0_nonnull=yes"
	AVOID_GNULIB+=" ac_cv_func_chown_works=yes"
	AVOID_GNULIB+=" ac_cv_func_getgroups_works=yes"
	AVOID_GNULIB+=" ac_cv_func_malloc_0_nonnull=yes"
	AVOID_GNULIB+=" ac_cv_func_realloc_0_nonnull=yes"
	AVOID_GNULIB+=" am_cv_func_working_getline=yes"
	AVOID_GNULIB+=" gl_cv_func_dup2_works=yes"
	AVOID_GNULIB+=" gl_cv_func_fcntl_f_dupfd_cloexec=yes"
	AVOID_GNULIB+=" gl_cv_func_fcntl_f_dupfd_works=yes"
	AVOID_GNULIB+=" gl_cv_func_fnmatch_posix=yes"
	AVOID_GNULIB+=" gl_cv_func_getcwd_abort_bug=no"
	AVOID_GNULIB+=" gl_cv_func_getcwd_null=yes"
	AVOID_GNULIB+=" gl_cv_func_getcwd_path_max=yes"
	AVOID_GNULIB+=" gl_cv_func_getcwd_posix_signature=yes"
	AVOID_GNULIB+=" gl_cv_func_gettimeofday_clobber=no"
	AVOID_GNULIB+=" gl_cv_func_gettimeofday_posix_signature=yes"
	AVOID_GNULIB+=" gl_cv_func_link_works=yes"
	AVOID_GNULIB+=" gl_cv_func_lstat_dereferences_slashed_symlink=yes"
	AVOID_GNULIB+=" gl_cv_func_malloc_0_nonnull=yes"
	AVOID_GNULIB+=" gl_cv_func_memchr_works=yes"
	AVOID_GNULIB+=" gl_cv_func_mkdir_trailing_dot_works=yes"
	AVOID_GNULIB+=" gl_cv_func_mkdir_trailing_slash_works=yes"
	AVOID_GNULIB+=" gl_cv_func_mkfifo_works=yes"
	AVOID_GNULIB+=" gl_cv_func_mknod_works=yes"
	AVOID_GNULIB+=" gl_cv_func_realpath_works=yes"
	AVOID_GNULIB+=" gl_cv_func_select_detects_ebadf=yes"
	AVOID_GNULIB+=" gl_cv_func_snprintf_posix=yes"
	AVOID_GNULIB+=" gl_cv_func_snprintf_retval_c99=yes"
	AVOID_GNULIB+=" gl_cv_func_snprintf_truncation_c99=yes"
	AVOID_GNULIB+=" gl_cv_func_stat_dir_slash=yes"
	AVOID_GNULIB+=" gl_cv_func_stat_file_slash=yes"
	AVOID_GNULIB+=" gl_cv_func_strerror_0_works=yes"
	AVOID_GNULIB+=" gl_cv_func_strtold_works=yes"
	AVOID_GNULIB+=" gl_cv_func_symlink_works=yes"
	AVOID_GNULIB+=" gl_cv_func_tzset_clobber=no"
	AVOID_GNULIB+=" gl_cv_func_unlink_honors_slashes=yes"
	AVOID_GNULIB+=" gl_cv_func_unlink_honors_slashes=yes"
	AVOID_GNULIB+=" gl_cv_func_vsnprintf_posix=yes"
	AVOID_GNULIB+=" gl_cv_func_vsnprintf_zerosize_c99=yes"
	AVOID_GNULIB+=" gl_cv_func_wcwidth_works=yes"
	AVOID_GNULIB+=" gl_cv_func_working_getdelim=yes"
	AVOID_GNULIB+=" gl_cv_func_working_mkstemp=yes"
	AVOID_GNULIB+=" gl_cv_func_working_mktime=yes"
	AVOID_GNULIB+=" gl_cv_func_working_strerror=yes"
	AVOID_GNULIB+=" gl_cv_header_working_fcntl_h=yes"
	AVOID_GNULIB+=" gl_cv_C_locale_sans_EILSEQ=yes"

	# Remove old config.log if it exists
	if [ -e "$MAGISK_MODULE_SRCDIR/config.log" ]; then
		rm -Rf $MAGISK_MODULE_SRCDIR/config.log;
	fi

	# NOTE: We do not want to quote AVOID_GNULIB as we want word expansion.
	# shellcheck disable=SC2086

	{
	magisk_log "running ./configure"
	env $AVOID_GNULIB "$MAGISK_MODULE_SRCDIR/configure" \
		--disable-dependency-tracking \
		--prefix=$MAGISK_PREFIX \
		--libdir=$MAGISK_PREFIX/lib \
		--includedir=$MAGISK_PREFIX/include \
		--disable-rpath --disable-rpath-hack \
		$HOST_FLAG \
		$MAGISK_MODULE_EXTRA_CONFIGURE_ARGS \
		$ENABLE_DATAROOT \
		$DISABLE_NLS \
		$ENABLE_STATIC \
		$DISABLE_SHARED \
		$LIBEXEC_FLAG \
		$VERBOSE_BUILD \
		#CFLAGS="${CFLAGS} -static" \
		#LDFLAGS="${LDFLAGS} --static"
	} && {
		magisk_log "./configure completed!";
	} || {
		 [[ -f "$MAGISK_MODULE_SRCDIR/config.log" ]] && cp $MAGISK_MODULE_SRCDIR/config.log $MAGISK_SCRIPTDIR/modules/$MAGISK_MODULE_NAME/debug/config.log;
	}
}
