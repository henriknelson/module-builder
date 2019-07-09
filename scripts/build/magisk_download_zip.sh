magisk_download_zip() {
	local PACKAGE=$1
	local PACKAGE_ARCH=$2
	local VERSION=$3
	local ZIP_FILE=${PACKAGE}_${VERSION}_${PACKAGE_ARCH}.zip
	PKG_HASH=""
	for idx in $(seq ${#MAGISK_REPO_URL[@]}); do
		local MAGISK_REPO_NAME=$(echo ${MAGISK_REPO_URL[$idx-1]} | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
		local PACKAGE_FILE_PATH="${MAGISK_REPO_NAME}-${MAGISK_REPO_DISTRIBUTION[$idx-1]}-${MAGISK_REPO_COMPONENT[$idx-1]}-Packages"
		if [ -f "${MAGISK_COMMON_CACHEDIR}-${PACKAGE_ARCH}/${PACKAGE_FILE_PATH}" ]; then
			read -d "\n" PKG_PATH PKG_HASH <<<$(./scripts/get_hash_from_file.py "${MAGISK_COMMON_CACHEDIR}-${PACKAGE_ARCH}/$PACKAGE_FILE_PATH" $PACKAGE $VERSION)
			if [ ! -z "$PKG_HASH" ]; then
				if [ ! "$MAGISK_QUIET_BUILD" = true ]; then
					echo "Found $PACKAGE in ${MAGISK_REPO_URL[$idx-1]}/dists/${MAGISK_REPO_DISTRIBUTION[$idx-1]}"
				fi
				break
			fi
		fi
	done
	if [ "$PKG_HASH" = "" ]; then
		return 1
	else
		magisk_download ${MAGISK_REPO_URL[$idx-1]}/${PKG_PATH} \
				$MAGISK_COMMON_CACHEDIR-$PACKAGE_ARCH/${ZIP_FILE} \
				$PKG_HASH
		return 0
	fi
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	magisk_download "$@"
fi
