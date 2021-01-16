MAGISK_MODULE_HOMEPAGE=https://www.rsnapshot.org/
MAGISK_MODULE_DESCRIPTION="A remote filesystem snapshot utility"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=1.4.3
MAGISK_MODULE_SRCURL=https://github.com/rsnapshot/rsnapshot/archive/$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=ab5f70f5b5db4f77f0156856bf4fd60eadb22b4dd6883bf4beb6d54b1bd4980d
MAGISK_MODULE_DEPENDS="coreutils, openssh, perl, rsync"
MAGISK_MODULE_PLATFORM_INDEPENDENT=true
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--with-perl=$MAGISK_PREFIX/bin/perl
--with-rsync=$MAGISK_PREFIX/bin/rsync
--with-rm=$MAGISK_PREFIX/bin/rm
--with-ssh=$MAGISK_PREFIX/bin/ssh
--with-du=$MAGISK_PREFIX/bin/du
"

MAGISK_MODULE_CONFFILES="etc/rsnapshot.conf"

magisk_step_pre_configure() {
	./autogen.sh
}

magisk_step_post_make_install() {
	mkdir -p $MAGISK_PREFIX/etc
	sed -e "s|@MAGISK_BASE_DIR@|/system|g" \
		-e "s|@MAGISK_PREFIX@|$MAGISK_PREFIX|g" \
		-e "s|@MAGISK_HOME@|$MAGISK_ANDROID_HOME|g" \
		$MAGISK_MODULE_BUILDER_DIR/rsnapshot.conf > $MAGISK_PREFIX/etc/rsnapshot.conf
}
