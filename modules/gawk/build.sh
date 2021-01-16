MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/gawk/
MAGISK_MODULE_DESCRIPTION="Programming language designed for text processing"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=5.1.0
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/gawk/gawk-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=cf5fea4ac5665fd5171af4716baab2effc76306a9572988d5ba1078f196382bd
MAGISK_MODULE_DEPENDS="libandroid-support, libgmp, libmpfr, readline"
MAGISK_MODULE_BREAKS="gawk-dev"
MAGISK_MODULE_REPLACES="gawk-dev"
MAGISK_MODULE_ESSENTIAL=true
MAGISK_MODULE_RM_AFTER_INSTALL="bin/gawk-* bin/igawk share/man/man1/igawk.1"

magisk_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $MAGISK_PREFIX.
	#if $MAGISK_ON_DEVICE_BUILD; then
	#	magisk_error_exit "Package '$MAGISK_MODULE_NAME' is not safe for on-device builds."
	#fi

	# Remove old symlink to force a fresh timestamp:
	rm -f $MAGISK_PREFIX/bin/awk
	export LDFLAGS+=" -static"
	# http://cross-lfs.org/view/CLFS-2.1.0/ppc64-64/temp-system/gawk.html
	cp -v extension/Makefile.in{,.orig}
	sed -e 's/check-recursive all-recursive: check-for-shared-lib-support/check-recursive all-recursive:/' extension/Makefile.in.orig > extension/Makefile.in
}
