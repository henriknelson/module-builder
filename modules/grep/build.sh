MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/grep/
MAGISK_MODULE_DESCRIPTION="Command which searches one or more input files for lines containing a match to a specified pattern"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=3.3
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/grep/grep-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=b960541c499619efd6afe1fa795402e4733c8e11ebf9fafccc0bb4bccdc5b514
MAGISK_MODULE_DEPENDS="libandroid-support, pcre"
MAGISK_MODULE_ESSENTIAL=yes

magisk_step_pre_configure() {
	if [ "$MAGISK_DEBUG" == "true" ]; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives this error:
		# /home/builder/.magisk-build/_cache/19b-aarch64-24-v5/bin/../sysroot/usr/include/bits/fortify/stdio.h:51:53: error: use of undeclared identifier '__USE_FORTIFY_LEVEL'
		# return __builtin___vsnprintf_chk(dest, size, 0, __bos(dest), format, ap);
		#                                                 ^
		# lib/cdefs.h:123:48: note: expanded from macro '__bos'
		# #define __bos(ptr) __builtin_object_size (ptr, __USE_FORTIFY_LEVEL > 1)
		#                                                ^
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}
