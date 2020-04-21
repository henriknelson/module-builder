MAGISK_MODULE_HOMEPAGE=https://termux.com/
MAGISK_MODULE_DESCRIPTION="Basic system tools for Termux"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=0.78
MAGISK_MODULE_SKIP_SRC_EXTRACT=true
MAGISK_MODULE_PLATFORM_INDEPENDENT=true
MAGISK_MODULE_ESSENTIAL=true
MAGISK_MODULE_CONFLICTS="procps (<< 3.3.15-2)"
MAGISK_MODULE_SUGGESTS="termux-api"
MAGISK_MODULE_CONFFILES="etc/motd"

# Some of these packages are not dependencies and used only to ensure
# that core packages are installed after upgrading (we removed busybox
# from essentials).
MAGISK_MODULE_DEPENDS="bzip2, coreutils, curl, dash, diffutils, findutils, gawk, grep, gzip, less, procps, psmisc, sed, tar, magisk-am, magisk-exec, util-linux, xz-utils, dialog"

# Optional packages that are distributed as part of bootstrap archives.
MAGISK_MODULE_RECOMMENDS="ed, dos2unix, inetutils, net-tools, patch, unzip"

magisk_step_make_install() {
	mkdir -p $MAGISK_PREFIX/bin/applets
	# Remove LD_LIBRARY_PATH from environment to avoid conflicting
	# with system libraries that system binaries may link against:
	for tool in df getprop logcat mount ping ping6 ip pm settings top umount; do
		WRAPPER_FILE=$MAGISK_PREFIX/bin/$tool
		echo '#!/bin/sh' > $WRAPPER_FILE
		echo 'unset LD_LIBRARY_PATH LD_PRELOAD' >> $WRAPPER_FILE
		# Some tools require having /system/bin/app_process in the PATH,
		# at least am&pm on a Nexus 6p running Android 6.0:
		echo -n 'PATH=$PATH:/system/bin ' >> $WRAPPER_FILE
		echo "exec /system/bin/$tool \"\$@\"" >> $WRAPPER_FILE
		chmod +x $WRAPPER_FILE
	done

	for script in chsh dalvikvm login pkg su termux-fix-shebang termux-info \
		termux-open termux-open-url termux-reload-settings termux-setup-storage \
		termux-wake-lock termux-wake-unlock termux-change-repo; do
			install -Dm700 $MAGISK_MODULE_BUILDER_DIR/$script $MAGISK_PREFIX/bin/$script
			perl -p -i -e "s%\@MAGISK_PREFIX\@%${MAGISK_PREFIX}%g" $MAGISK_PREFIX/bin/$script
	done

	install -Dm600 $MAGISK_MODULE_BUILDER_DIR/motd $MAGISK_PREFIX/etc/motd
	ln -sfr $MAGISK_PREFIX/bin/termux-open $MAGISK_PREFIX/bin/xdg-open
}
