magisk_step_setup_variables() {
	# shellcheck source=scripts/properties.sh
	. "$MAGISK_SCRIPTDIR/scripts/properties.sh"
	: "${MAGISK_MAKE_PROCESSES:="$(nproc)"}"
	: "${MAGISK_TOPDIR:="$HOME/.magisk-build"}"
	: "${MAGISK_ARCH:="aarch64"}" # arm, aarch64, i686 or x86_64.
	: "${MAGISK_PREFIX:="/system"}"
	: "${MAGISK_ANDROID_HOME:="$HOME/android"}"
	: "${MAGISK_DEBUG:=""}"
	: "${MAGISK_MODULE_API_LEVEL:="24"}"
	: "${MAGISK_NO_CLEAN:="false"}"
	: "${MAGISK_QUIET_BUILD:="false"}"
	: "${MAGISK_ZIPDIR:="${MAGISK_SCRIPTDIR}/zips"}"
	: "${MAGISK_SKIP_DEPCHECK:="false"}"
	: "${MAGISK_INSTALL_DEPS:="false"}"
	: "${MAGISK_MODULE_MAINTAINER:="Henrik Nelson henrik@cliffords.nu"}"
	: "${MAGISK_MODULES_DIRECTORIES:="modules"}"

	MAGISK_REPO_URL=(
		https://dl.bintray.com/termux/termux-packages-24
		https://dl.bintray.com/grimler/game-packages-24
		https://dl.bintray.com/grimler/science-packages-24
		https://dl.bintray.com/grimler/termux-root-packages-24
		https://dl.bintray.com/xeffyr/unstable-packages-24
		https://dl.bintray.com/xeffyr/x11-packages-24
	)

	MAGISK_REPO_DISTRIBUTION=(
		stable
		games
		science
		root
		unstable
		x11
	)

	MAGISK_REPO_COMPONENT=(
		main
		stable
		stable
		stable
		main
		main
	)

	if [ "x86_64" = "$MAGISK_ARCH" ] || [ "aarch64" = "$MAGISK_ARCH" ]; then
		MAGISK_ARCH_BITS=64
	else
		MAGISK_ARCH_BITS=32
	fi

	MAGISK_HOST_PLATFORM="${MAGISK_ARCH}-linux-android"
	if [ "$MAGISK_ARCH" = "arm" ]; then MAGISK_HOST_PLATFORM="${MAGISK_HOST_PLATFORM}eabi"; fi

	if [ ! -d "$NDK" ]; then
		magisk_error_exit 'NDK not pointing at a directory!'
	fi
	if ! grep -s -q "Pkg.Revision = $MAGISK_NDK_VERSION_NUM" "$NDK/source.properties"; then
		magisk_error_exit "Wrong NDK version - we need $MAGISK_NDK_VERSION"
	fi

	# The build tuple that may be given to --build configure flag:
	MAGISK_BUILD_TUPLE=$(sh "$MAGISK_SCRIPTDIR/scripts/config.guess")

	# We do not put all of build-tools/$MAGISK_ANDROID_BUILD_TOOLS_VERSION/ into PATH
	# to avoid stuff like arm-linux-androideabi-ld there to conflict with ones from
	# the standalone toolchain.
	MAGISK_D8=$ANDROID_HOME/build-tools/$MAGISK_ANDROID_BUILD_TOOLS_VERSION/d8

	MAGISK_COMMON_CACHEDIR="$MAGISK_TOPDIR/_cache"
	#MAGISK_ELF_CLEANER=$MAGISK_COMMON_CACHEDIR/termux-elf-cleaner

	export prefix=${MAGISK_PREFIX}
	export PREFIX=${MAGISK_PREFIX}

	MAGISK_MODULE_BUILDDIR=$MAGISK_TOPDIR/$MAGISK_MODULE_NAME/build
	MAGISK_MODULE_CACHEDIR=$MAGISK_TOPDIR/$MAGISK_MODULE_NAME/cache
	MAGISK_MODULE_MASSAGEDIR=$MAGISK_TOPDIR/$MAGISK_MODULE_NAME/massage
	MAGISK_MODULE_MODULEDIR=$MAGISK_TOPDIR/$MAGISK_MODULE_NAME/module
	MAGISK_MODULE_SRCDIR=$MAGISK_TOPDIR/$MAGISK_MODULE_NAME/src
	MAGISK_MODULE_SHA256=""
	MAGISK_MODULE_TMPDIR=$MAGISK_TOPDIR/$MAGISK_MODULE_NAME/tmp
	MAGISK_MODULE_HOSTBUILD_DIR=$MAGISK_TOPDIR/$MAGISK_MODULE_NAME/host-build
	MAGISK_MODULE_PLATFORM_INDEPENDENT=""
	MAGISK_MODULE_NO_DEVELSPLIT=""
	MAGISK_MODULE_REVISION="0" # http://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Version
	MAGISK_MODULE_EXTRA_CONFIGURE_ARGS=""
	MAGISK_MODULE_EXTRA_HOSTBUILD_CONFIGURE_ARGS=""
	MAGISK_MODULE_EXTRA_MAKE_ARGS=""
	MAGISK_MODULE_BUILD_IN_SRC=""
	MAGISK_MODULE_RM_AFTER_INSTALL=""
	MAGISK_MODULE_BREAKS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-binarydeps
	MAGISK_MODULE_PRE_DEPENDS=""
	MAGISK_MODULE_DEPENDS=""
	MAGISK_MODULE_BUILD_DEPENDS=""
	MAGISK_MODULE_HOMEPAGE=""
	MAGISK_MODULE_DESCRIPTION="FIXME:Add description"
	MAGISK_MODULE_LICENSE_FILE="" # Relative path from $MAGISK_MODULE_SRCDIR to LICENSE file. It is installed to $PREFIX/share/$MAGISK_MODULE_NAME.
	MAGISK_MODULE_KEEP_STATIC_LIBRARIES="false"
	MAGISK_MODULE_ESSENTIAL=""
	MAGISK_MODULE_CONFLICTS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-conflicts
	MAGISK_MODULE_RECOMMENDS="" # https://www.debian.org/doc/debian-policy/ch-relationships.html#s-binarydeps
	MAGISK_MODULE_SUGGESTS=""
	MAGISK_MODULE_REPLACES=""
	MAGISK_MODULE_PROVIDES="" #https://www.debian.org/doc/debian-policy/#virtual-modules-provides
	MAGISK_MODULE_CONFFILES=""
	MAGISK_MODULE_INCLUDE_IN_DEVMODULE=""
	MAGISK_MODULE_DEVMODULE_DEPENDS=""
	MAGISK_MODULE_DEVMODULE_BREAKS=""
	MAGISK_MODULE_DEVMODULE_REPLACES=""
	# Set if a host build should be done in MAGISK_MODULE_HOSTBUILD_DIR:
	MAGISK_MODULE_HOSTBUILD=""
	MAGISK_MODULE_FORCE_CMAKE=no # if the module has autotools as well as cmake, then set this to prefer cmake
	MAGISK_CMAKE_BUILD=Ninja # Which cmake generator to use
	MAGISK_MODULE_HAS_DEBUG=yes # set to no if debug build doesn't exist or doesn't work, for example for python based modules

	unset CFLAGS CPPFLAGS LDFLAGS CXXFLAGS
}
