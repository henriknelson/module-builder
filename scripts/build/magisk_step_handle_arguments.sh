magisk_step_handle_arguments() {
	_show_usage() {
	    echo "Usage: ./build-module.sh [-a ARCH] [-d] [-D] [-f] [-i] [-I] [-q] [-s] [-o DIR] MODULE"
	    echo "Build a module by creating a .zip file in the zips/ folder."
	    echo "  -a The architecture to build for: aarch64(default), arm, i686, x86_64 or all."
	    echo "  -d Build with debug symbols."
	    echo "  -D Build a disabled module in disabled-modules/."
	    echo "  -f Force build even if module has already been built."
	    echo "  -i Download and extract dependencies instead of building them."
	    echo "  -I Download and extract dependencies instead of building them, keep existing files."
	    echo "  -q Quiet build."
	    echo "  -s Skip dependency check."
	    echo "  -o Specify zip directory. Default: zips/."
	    exit 1
	}
	while getopts :a:hdDfiIqso: option; do
		case "$option" in
		a) MAGISK_ARCH="$OPTARG";;
		h) _show_usage;;
		d) export MAGISK_DEBUG=true;;
		D) local MAGISK_IS_DISABLED=true;;
		f) MAGISK_FORCE_BUILD=true;;
		i) export MAGISK_INSTALL_DEPS=true;;
		I) export MAGISK_INSTALL_DEPS=true && export MAGISK_NO_CLEAN=true;;
		q) export MAGISK_QUIET_BUILD=true;;
		s) export MAGISK_SKIP_DEPCHECK=true;;
		o) MAGISK_ZIPDIR="$(realpath -m $OPTARG)";;
		?) magisk_error_exit "./build-module.sh: illegal option -$OPTARG";;
		esac
	done
	shift $((OPTIND-1))

	if [ "$#" -ne 1 ]; then _show_usage; fi
	unset -f _show_usage

	# Handle 'all' arch:
	if [ -n "${MAGISK_ARCH+x}" ] && [ "${MAGISK_ARCH}" = 'all' ]; then
		for arch in 'aarch64' 'arm' 'i686' 'x86_64'; do
			MAGISK_BUILD_IGNORE_LOCK=true ./build-module.sh ${MAGISK_FORCE_BUILD+-f} \
				-a $arch ${MAGISK_INSTALL_DEPS+-i} ${MAGISK_IS_DISABLED+-D} ${MAGISK_DEBUG+-d} \
				${MAGISK_ZIPDIR+-o $MAGISK_ZIPDIR} "$1"
		done
		exit
	fi

	# Check the module to build:
	MAGISK_MODULE_NAME=$(basename "$1")

	export MAGISK_SCRIPTDIR
	MAGISK_SCRIPTDIR=$(cd "$(dirname "$0")"; pwd)
	if [[ $1 == *"/"* ]]; then
		# Path to directory which may be outside this repo:
		if [ ! -d "$1" ]; then magisk_error_exit "'$1' seems to be a path but is not a directory"; fi
		export MAGISK_MODULE_BUILDER_DIR
		MAGISK_MODULE_BUILDER_DIR=$(realpath "$1")
	else
		# Package name:
		if [ -n "${MAGISK_IS_DISABLED=""}" ]; then
			export MAGISK_MODULE_BUILDER_DIR=$MAGISK_SCRIPTDIR/disabled-modules/$MAGISK_MODULE_NAME
		else
			export MAGISK_MODULE_BUILDER_DIR=$MAGISK_SCRIPTDIR/modules/$MAGISK_MODULE_NAME
		fi
	fi

	MAGISK_MODULE_BUILDER_SCRIPT=$MAGISK_MODULE_BUILDER_DIR/build.sh
	if test ! -f "$MAGISK_MODULE_BUILDER_SCRIPT"; then
		magisk_error_exit "No build.sh script at module dir $MAGISK_MODULE_BUILDER_DIR!"
	fi
}
