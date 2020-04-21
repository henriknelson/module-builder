MAGISK_MODULE_HOMEPAGE=https://en.wikipedia.org/wiki/Util-linux
MAGISK_MODULE_DESCRIPTION="Miscellaneous system utilities"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.35.1
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://www.kernel.org/pub/linux/utils/util-linux/v${MAGISK_MODULE_VERSION:0:4}/util-linux-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=d9de3edd287366cd908e77677514b9387b22bc7b88f45b83e1922c3597f1d7f9
MAGISK_MODULE_DEPENDS="ncurses, libcrypt, zlib"
MAGISK_MODULE_ESSENTIAL=true
MAGISK_MODULE_BREAKS="util-linux-dev"
MAGISK_MODULE_REPLACES="util-linux-dev"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_func_setns=yes
ac_cv_func_unshare=yes
--disable-agetty
--disable-ctrlaltdel
--disable-eject
--disable-fdformat
--disable-ipcrm
--disable-ipcs
--disable-kill
--disable-last
--disable-libuuid
--disable-logger
--disable-mesg
--disable-nologin
--disable-pivot_root
--disable-raw
--disable-switch_root
--disable-wall
--disable-libmount
--disable-lsmem
--disable-chmem
--disable-rfkill
--disable-hwclock-cmos
"

magisk_step_pre_configure() {
	if [ $MAGISK_ARCH_BITS = 64 ]; then
		# prlimit() is only available in 64-bit bionic.
		MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_prlimit=yes"
	fi
}
