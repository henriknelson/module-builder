MAGISK_MODULE_HOMEPAGE=https://busybox.net/
MAGISK_MODULE_DESCRIPTION="Tiny versions of many common UNIX utilities into a single small executable"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=1.32.0
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SRCURL=https://busybox.net/downloads/busybox-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=c35d87f1d04b2b153d33c275c2632e40d388a88f19a9e71727e0bbbff51fe689
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_SERVICE_SCRIPT=(
	"telnetd" 'exec busybox telnetd -F'
	"ftpd" 'exec busybox tcpsvd -vE 0.0.0.0 8021 busybox ftpd -w $HOME'
)

mmagisk_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $MAGISK_PREFIX.
	if $MAGISK_ON_DEVICE_BUILD; then
		magisk_error_exit "Package '$MAGISK_MODULE_NAME' is not safe for on-device builds."
	fi
}

magisk_step_configure() {
	# Prevent spamming logs with useless warnings to make them more readable.
	CFLAGS+=" -Wno-ignored-optimization-argument -Wno-unused-command-line-argument"

	sed -e "s|@MAGISK_PREFIX@|$MAGISK_PREFIX|g" \
		-e "s|@MAGISK_SYSROOT@|$MAGISK_STANDALONE_TOOLCHAIN/sysroot|g" \
		-e "s|@MAGISK_HOST_PLATFORM@|${MAGISK_HOST_PLATFORM}|g" \
		-e "s|@MAGISK_CFLAGS@|$CFLAGS|g" \
		-e "s|@MAGISK_LDFLAGS@|$LDFLAGS|g" \
		-e "s|@MAGISK_LDLIBS@|log|g" \
		$MAGISK_MODULE_BUILDER_DIR/busybox.config > .config

	unset CFLAGS LDFLAGS
	make oldconfig
}

magisk_step_post_make_install() {
	if $MAGISK_DEBUG; then
		install -Dm700 busybox_unstripped $PREFIX/bin/busybox
	fi

	# Install busybox man page.
	install -Dm600 -t $MAGISK_PREFIX/share/man/man1 $MAGISK_MODULE_SRCDIR/docs/busybox.1
}
