MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/gawk/
MAGISK_MODULE_DESCRIPTION="Programming language designed for text processing"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=5.0.1
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/gawk/gawk-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=8e4e86f04ed789648b66f757329743a0d6dfb5294c3b91b756a474f1ce05a794
MAGISK_MODULE_DEPENDS="libandroid-support, libgmp, libmpfr, readline"
MAGISK_MODULE_BREAKS="gawk-dev"
MAGISK_MODULE_REPLACES="gawk-dev"
MAGISK_MODULE_RM_AFTER_INSTALL="bin/gawk-* bin/igawk share/man/man1/igawk.1"

magisk_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $MAGISK_PREFIX.
	# Remove old symlink to force a fresh timestamp:
	rm -f $MAGISK_PREFIX/bin/awk

	# http://cross-lfs.org/view/CLFS-2.1.0/ppc64-64/temp-system/gawk.html
	cp -v extension/Makefile.in{,.orig}
	sed -e 's/check-recursive all-recursive: check-for-shared-lib-support/check-recursive all-recursive:/' extension/Makefile.in.orig > extension/Makefile.in
}
