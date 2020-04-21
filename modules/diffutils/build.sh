MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/diffutils/
MAGISK_MODULE_DESCRIPTION="Programs (cmp, diff, diff3 and sdiff) related to finding differences between files"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=3.7
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/diffutils/diffutils-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=b3a7a6221c3dc916085f0d205abf6b8e1ba443d4dd965118da364a1dc1cb3a26
MAGISK_MODULE_DEPENDS="libiconv"
MAGISK_MODULE_ESSENTIAL=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="ac_cv_path_PR_PROGRAM=${MAGISK_PREFIX}/bin/pr"

magisk_step_pre_configure() {
	if $MAGISK_DEBUG; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives an
		# error: use of undeclared identifier '__USE_FORTIFY_LEVEL'
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}
