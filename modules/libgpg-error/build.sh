MAGISK_MODULE_HOMEPAGE=https://www.gnupg.org/related_software/libgpg-error/
MAGISK_MODULE_DESCRIPTION="Small library that defines common error values for all GnuPG components"
MAGISK_MODULE_LICENSE="LGPL-2.0"
MAGISK_MODULE_VERSION=1.39
MAGISK_MODULE_SRCURL=https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=4a836edcae592094ef1c5a4834908f44986ab2b82e0824a0344b49df8cdb298f
MAGISK_MODULE_BREAKS="libgpg-error-dev"
MAGISK_MODULE_REPLACES="libgpg-error-dev"
MAGISK_MODULE_RM_AFTER_INSTALL="share/common-lisp"

magisk_step_post_get_source() {
	# Upstream only has Android definitions for platform-specific lock objects.
	# See https://lists.gnupg.org/pipermail/gnupg-devel/2014-January/028203.html
	# for how to generate a lock-obj header file on devices.

	# For aarch64 this was generated on a device:
	cp $MAGISK_MODULE_BUILDER_DIR/lock-obj-pub.aarch64-unknown-linux-android.h $MAGISK_MODULE_SRCDIR/src/syscfg/

	if [ $MAGISK_ARCH = i686 ]; then
		# Android i686 has same config as arm (verified by generating a file on a i686 device):
		cp $MAGISK_MODULE_SRCDIR/src/syscfg/lock-obj-pub.arm-unknown-linux-androideabi.h \
		   $MAGISK_MODULE_SRCDIR/src/syscfg/lock-obj-pub.linux-android.h
	elif [ $MAGISK_ARCH = x86_64 ]; then
		# FIXME: Generate on device.
		cp $MAGISK_MODULE_BUILDER_DIR/lock-obj-pub.aarch64-unknown-linux-android.h \
			$MAGISK_MODULE_SRCDIR/src/syscfg/lock-obj-pub.linux-android.h
	fi
}

magisk_step_pre_configure() {
	autoreconf -fi
	# USE_POSIX_THREADS_WEAK is being enabled for on-device build and causes
	# errors, so force-disable it.
	sed -i 's/USE_POSIX_THREADS_WEAK/DONT_USE_POSIX_THREADS_WEAK/g' configure
}
