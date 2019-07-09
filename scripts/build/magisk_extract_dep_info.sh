magisk_extract_dep_info() {
	MODULE=$1
	MODULE_DIR=$2
	if [ "$MODULE" != "$(basename ${MODULE_DIR})" ]; then
		# We are dealing with a submodule
		MAGISK_ARCH=$(
			# set MAGISK_SUBMODULE_PLATFORM_INDEPENDENT to parent module's value and override if needed
			MAGISK_MODULE_PLATFORM_INDEPENDENT=""
			source ${MODULE_DIR}/build.sh
			MAGISK_SUBMODULE_PLATFORM_INDEPENDENT=$MAGISK_MODULE_PLATFORM_INDEPENDENT
			if [ "$MAGISK_INSTALL_DEPS" = false ] || [ -n "${MAGISK_MODULE_NO_DEVELSPLIT}" ] || [ "${MODULE/-dev/}-dev" != "${MODULE}" ]; then
				source ${MODULE_DIR}/${MODULE}.submodule.sh
			fi
			if [ "$MAGISK_SUBMODULE_PLATFORM_INDEPENDENT" = yes ]; then
				echo all
			else
				echo $MAGISK_ARCH
			fi
		)

	elif [ "${MODULE/-dev/}-dev" == "${MODULE}" ]; then
		# dev module
		MODULE=${MODULE/-dev/}
	fi
	(
		# Reset MAGISK_MODULE_PLATFORM_INDEPENDENT and MAGISK_MODULE_REVISION since these aren't
		# mandatory in a build.sh. Otherwise these will equal the main module's values for
		# deps that should have the default values
		MAGISK_MODULE_PLATFORM_INDEPENDENT=""
		MAGISK_MODULE_REVISION="0"
		source ${MODULE_DIR}/build.sh
		if [ "$MAGISK_MODULE_PLATFORM_INDEPENDENT" = yes ]; then MAGISK_ARCH=all; fi
		if [ "$MAGISK_MODULE_REVISION" != "0" ] || [ "$MAGISK_MODULE_VERSION" != "${MAGISK_MODULE_VERSION/-/}" ]; then
			MAGISK_MODULE_VERSION+="-$MAGISK_MODULE_REVISION"
		fi
		echo ${MAGISK_ARCH} ${MAGISK_MODULE_VERSION}
	)
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	magisk_extract_dep_info "$@"
fi
