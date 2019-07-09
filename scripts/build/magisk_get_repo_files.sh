magisk_get_repo_files() {
	# Ensure folders present (but not $MAGISK_MODULE_SRCDIR, it will be created in build)
	mkdir -p "$MAGISK_COMMON_CACHEDIR" \
		 "$MAGISK_COMMON_CACHEDIR-$MAGISK_ARCH" \
		 "$MAGISK_COMMON_CACHEDIR-all" \
		 "$MAGISK_ZIPDIR" \
		 "$MAGISK_MODULE_BUILDDIR" \
		 "$MAGISK_MODULE_MODULEDIR" \
		 "$MAGISK_MODULE_TMPDIR" \
		 "$MAGISK_MODULE_CACHEDIR" \
		 "$MAGISK_MODULE_MASSAGEDIR" \
		 $MAGISK_PREFIX/{bin,etc,lib,libexec,share,tmp,include}
	if [ "$MAGISK_INSTALL_DEPS" = true ]; then
		if [ "$MAGISK_NO_CLEAN" = false ]; then
			# Remove all previously extracted/built files from $MAGISK_PREFIX:
			rm -rf $MAGISK_PREFIX
			rm -f /data/data/.built-modules/*
		fi

		for idx in $(seq ${#MAGISK_REPO_URL[@]}); do
			local MAGISK_REPO_NAME=$(echo ${MAGISK_REPO_URL[$idx-1]} | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
			local RELEASE_FILE=${MAGISK_COMMON_CACHEDIR}/${MAGISK_REPO_NAME}-${MAGISK_REPO_DISTRIBUTION[$idx-1]}-Release

			magisk_download "${MAGISK_REPO_URL[$idx-1]}/dists/${MAGISK_REPO_DISTRIBUTION[$idx-1]}/Release" \
				"$RELEASE_FILE" SKIP_CHECKSUM

			for arch in all $MAGISK_ARCH; do
				local MODULES_HASH=$(./scripts/get_hash_from_file.py ${RELEASE_FILE} $arch ${MAGISK_REPO_COMPONENT[$idx-1]})
				# If modules_hash = "" then the repo probably doesn't contain debs for $arch
				if [ ! -z "$MODULES_HASH" ]; then
					magisk_download "${MAGISK_REPO_URL[$idx-1]}/dists/${MAGISK_REPO_DISTRIBUTION[$idx-1]}/${MAGISK_REPO_COMPONENT[$idx-1]}/binary-$arch/Packages" \
							"${MAGISK_COMMON_CACHEDIR}-$arch/${MAGISK_REPO_NAME}-${MAGISK_REPO_DISTRIBUTION[$idx-1]}-${MAGISK_REPO_COMPONENT[$idx-1]}-Packages" \
							$MODULES_HASH
				fi
			done
		done
	fi
}
