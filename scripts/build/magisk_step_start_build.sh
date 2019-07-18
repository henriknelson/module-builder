magisk_step_start_build() {
	# shellcheck source=/dev/null
	source "$MAGISK_MODULE_BUILDER_SCRIPT"

	MAGISK_STANDALONE_TOOLCHAIN="$MAGISK_COMMON_CACHEDIR/android-r${MAGISK_NDK_VERSION}-api-${MAGISK_MODULE_API_LEVEL}"
	# Bump the below version if a change is made in toolchain setup to ensure
	# that everyone gets an updated toolchain:
	MAGISK_STANDALONE_TOOLCHAIN+="-v1"

	if [ -n "${MAGISK_MODULE_BLACKLISTED_ARCHES:=""}" ] && [ "$MAGISK_MODULE_BLACKLISTED_ARCHES" != "${MAGISK_MODULE_BLACKLISTED_ARCHES/$MAGISK_ARCH/}" ]; then
		magisk_log "skipping building $MAGISK_MODULE_NAME for arch $MAGISK_ARCH - arch blacklisted"
		exit 0
	fi

	MAGISK_MODULE_FULLVERSION=$MAGISK_MODULE_VERSION
	if [ "$MAGISK_MODULE_REVISION" != "0" ] || [ "$MAGISK_MODULE_FULLVERSION" != "${MAGISK_MODULE_FULLVERSION/-/}" ]; then
		# "0" is the default revision, so only include it if the upstream versions contains "-" itself
		MAGISK_MODULE_FULLVERSION+="-$MAGISK_MODULE_REVISION"
	fi

	if [ "$MAGISK_DEBUG" = true ]; then
		if [ "$MAGISK_MODULE_HAS_DEBUG" == "yes" ]; then
			DEBUG="-dbg"
		else
			magisk_log "skipping building debug build for $MAGISK_MODULE_NAME - MAGISK_MODULE_HAS_DEBUG='no'"
			exit 0
		fi
	else
		DEBUG=""
	fi

	if [ -z "$MAGISK_DEBUG" ] &&
	   [ -z "${MAGISK_FORCE_BUILD+x}" ] &&
	   [ -e "/data/data/.built-modules/$MAGISK_MODULE_NAME" ]; then
		if [ "$(cat "/data/data/.built-modules/$MAGISK_MODULE_NAME")" = "$MAGISK_MODULE_FULLVERSION" ]; then
			magisk_log "$MAGISK_MODULE_NAME@$MAGISK_MODULE_FULLVERSION already built - skipping (rm /data/data/.built-modules/$MAGISK_MODULE_NAME to force rebuild)"
			exit 0
		fi
	fi

	if [ "$MAGISK_SKIP_DEPCHECK" = false ] && [ "$MAGISK_INSTALL_DEPS" = true ]; then
		# Download repo files
		magisk_get_repo_files
		# Download dependencies
		while read MODULE MODULE_DIR; do
			if [ -z $MODULE ]; then
				continue
			elif [ "$MODULE" = "ERROR" ]; then
				magisk_error_exit "Obtaining buildorder failed"
			fi
			# llvm doesn't build if ndk-sysroot is installed:
			if [ "$MODULE" = "ndk-sysroot" ]; then continue; fi
			read DEP_ARCH DEP_VERSION <<< $(magisk_extract_dep_info $MODULE "${MODULE_DIR}")

			if [ ! "$MAGISK_QUIET_BUILD" = true ]; then
				magisk_log "downloading dependency $MODULE@$DEP_VERSION if necessary..."
			fi

			if [ -e "/data/data/.built-modules/$MODULE" ]; then
				if [ "$(cat "/data/data/.built-modules/$MODULE")" = "$DEP_VERSION" ]; then
					continue
				fi
			fi

			if ! magisk_download_zip $MODULE $DEP_ARCH $DEP_VERSION; then
				magisk_log "download of $MODULE@$DEP_VERSION from $MAGISK_REPO_URL failed, building instead"
				MAGISK_BUILD_IGNORE_LOCK=true ./build-module.sh -a $MAGISK_ARCH -I "${MODULE_DIR}"
				continue
			else
				if [ ! "$MAGISK_QUIET_BUILD" = true ]; then
					magisk_log "extracting $MODULE...";
				fi
				(
					cd $MAGISK_COMMON_CACHEDIR-$DEP_ARCH
					ar x ${MODULE}_${DEP_VERSION}_${DEP_ARCH}.deb data.tar.xz
					tar -xf data.tar.xz --no-overwrite-dir -C /
				)
			fi

			mkdir -p /data/data/.built-modules
			echo "$DEP_VERSION" > "/data/data/.built-modules/$MODULE"
		cat "/data/data/.built-modules/$MODULE"
		done<<<$(./scripts/buildorder.py -i "$MAGISK_MODULE_BUILDER_DIR" $MAGISK_MODULES_DIRECTORIES || echo "ERROR")
	elif [ "$MAGISK_SKIP_DEPCHECK" = false ] && [ "$MAGISK_INSTALL_DEPS" = false ]; then
		# Build dependencies
		while read MODULE MODULE_DIR; do
			if [ -z $MODULE ]; then
				continue
			elif [ "$MODULE" = "ERROR" ]; then
				magisk_error_exit "Obtaining buildorder failed"
			fi
			magisk_log "trying to build dependency $MODULE if necessary..."
			# Built dependencies are put in the default MAGISK_ZIPDIR instead of the specified one
			MAGISK_BUILD_IGNORE_LOCK=true ./build-module.sh -a $MAGISK_ARCH -s "${MODULE_DIR}"
		done<<<$(./scripts/buildorder.py "$MAGISK_MODULE_BUILDER_DIR" $MAGISK_MODULES_DIRECTORIES || echo "ERROR")
	fi

	# Cleanup old state:
	rm -Rf "$MAGISK_MODULE_BUILDDIR" \
		"$MAGISK_MODULE_MODULEDIR" \
		"$MAGISK_MODULE_SRCDIR" \
		"$MAGISK_MODULE_TMPDIR" \
		"$MAGISK_MODULE_MASSAGEDIR"

	# Ensure folders present (but not $MAGISK_MODULE_SRCDIR, it will be created in build)
	mkdir -p "$MAGISK_COMMON_CACHEDIR" \
		 "$MAGISK_ZIPDIR" \
		 "$MAGISK_MODULE_BUILDDIR" \
		 "$MAGISK_MODULE_MODULEDIR" \
		 "$MAGISK_MODULE_TMPDIR" \
		 "$MAGISK_MODULE_CACHEDIR" \
		 "$MAGISK_MODULE_MASSAGEDIR" \
		 $MAGISK_PREFIX/{bin,etc,lib,libexec,share,share/LICENSES,tmp,include}

	# Make $MAGISK_PREFIX/bin/sh executable on the builder, so that build
	# scripts can assume that it works on both builder and host later on:
	ln -f -s /bin/sh "$MAGISK_PREFIX/bin/sh"

	#local MAGISK_ELF_CLEANER_SRC=$MAGISK_COMMON_CACHEDIR/termux-elf-cleaner.cpp
	#local MAGISK_ELF_CLEANER_VERSION
	#MAGISK_ELF_CLEANER_VERSION=$(bash -c ". $MAGISK_SCRIPTDIR/modules/termux-elf-cleaner/build.sh; echo \$MAGISK_MODULE_VERSION")
	#magisk_download \
	#	"https://raw.githubusercontent.com/termux/termux-elf-cleaner/v$MAGISK_ELF_CLEANER_VERSION/termux-elf-cleaner.cpp" \
	#	"$MAGISK_ELF_CLEANER_SRC" \
	#	96044b5e0a32ba9ce8bea96684a0723a9b777c4ae4b6739eaafc444dc23f6d7a
	#if [ "$MAGISK_ELF_CLEANER_SRC" -nt "$MAGISK_ELF_CLEANER" ]; then
	#	g++ -std=c++11 -Wall -Wextra -pedantic -Os -D__ANDROID_API__=$MAGISK_MODULE_API_LEVEL \
	#		"$MAGISK_ELF_CLEANER_SRC" -o "$MAGISK_ELF_CLEANER"
	#fi

	if [ -n "$MAGISK_MODULE_BUILD_IN_SRC" ]; then
		echo "building in src due to MAGISK_MODULE_BUILD_IN_SRC being set" > "$MAGISK_MODULE_BUILDDIR/BUILDING_IN_SRC.txt"
		MAGISK_MODULE_BUILDDIR=$MAGISK_MODULE_SRCDIR
	fi

	magisk_log "trying to build module '$MAGISK_MODULE_NAME' for arch $MAGISK_ARCH..."
	test -t 1 && printf "\033]0;%s...\007" "$MAGISK_MODULE_NAME"

	# Avoid exporting MODULE_CONFIG_LIBDIR until after magisk_step_host_build.
	export MAGISK_MODULE_CONFIG_LIBDIR=$MAGISK_PREFIX/lib/pkgconfig

	# Keep track of when build started so we can see what files have been created.
	# We start by sleeping so that any generated files above (such as zlib.pc) get
	# an older timestamp than the MAGISK_BUILD_TS_FILE.
	sleep 1
	MAGISK_BUILD_TS_FILE=$MAGISK_MODULE_TMPDIR/timestamp_$MAGISK_MODULE_NAME
	touch "$MAGISK_BUILD_TS_FILE"
}
