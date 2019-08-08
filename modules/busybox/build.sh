MAGISK_MODULE_HOMEPAGE=https://busybox.net/
MAGISK_MODULE_DESCRIPTION="Tiny versions of many common UNIX utilities into a single small executable"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_ESSENTIAL=yes
MAGISK_MODULE_VERSION=1.31.0
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SHA256=0e4925392fd9f3743cc517e031b68b012b24a63b0cf6c1ff03cce7bb3846cc99
MAGISK_MODULE_SRCURL=https://busybox.net/downloads/busybox-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_BUILD_IN_SRC=yes
MAGISK_MODULE_DEPENDS="libcares"

# We replace env in the old coreutils package:
MAGISK_MODULE_CONFLICTS="coreutils (<< 8.25-4)"

#magisk_step_pre_configure() {
#	export TARGET=aarch64-linux-musl
#}

magisk_step_configure() {
	make clean
	cp -f $MAGISK_MODULE_BUILDER_DIR/busybox.config .config
	cp -f $MAGISK_MODULE_BUILDER_DIR/files/* .
	echo "CONFIG_SYSROOT=\"$MAGISK_STANDALONE_TOOLCHAIN/sysroot\"" >> .config
	echo "CONFIG_PREFIX=\"$MAGISK_PREFIX\"" >> .config
	echo "CONFIG_CROSS_COMPILER_PREFIX=\"$MAGISK_HOST_PLATFORM-\"" >> .config
	echo "CONFIG_FEATURE_CROND_DIR=\"$MAGISK_PREFIX/var/spool/cron\"" >> .config
	echo "CONFIG_SV_DEFAULT_SERVICE_DIR=\"$MAGISK_PREFIX/var/service\"" >> .config
	make oldconfig
}

mmagisk_step_make() {
	MUSL_PATH=/usr/local/musl/bin
	export PATH=$MUSL_PATH:$PATH
	export CC=$MUSL_PATH/${TARGET}-gcc
	export CFLAGS=" -g -O0"
	CC=$CC make

	mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin
	tree "$MAGISK_MODULE_MASSAGEDIR" > ~/out.log
	cp $MAGISK_MODULE_SRCDIR/busybox $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/
	#for f in $(cat $MAGISK_MODULE_SRCDIR/busybox.links); do ln -s ../busybox $(basename $f); done
}

magisk_step_post_make_install() {
	if [ "$MAGISK_DEBUG" == "true" ]; then
		install busybox_unstripped $MAGISK_PREFIX/bin/busybox
	fi

	# Create symlinks in $PREFIX/bin/applets to $PREFIX/bin/busybox
	rm -Rf $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/applets
	mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/applets
	cd $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/applets
	for f in $(cat $MAGISK_MODULE_SRCDIR/busybox.links); do ln -s ../busybox $(basename $f); done

	# The 'env' applet is special in that it go into $PREFIX/bin:
	cd $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin
	ln -f -s busybox env

	# Install busybox man page
	#mkdir -p $MAGISK_PREFIX/share/man/man1
	#cp $MAGISK_MODULE_SRCDIR/docs/busybox.1 $MAGISK_PREFIX/share/man/man1

	# Needed for 'crontab -e' to work out of the box:
	local _CRONTABS=$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/var/spool/cron/crontabs
	mkdir -p $_CRONTABS
	echo "Used by the busybox crontab and crond tools" > $_CRONTABS/README.magisk

	# Setup some services
	mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/var/service
	cd $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/var/service
	mkdir -p ftpd telnetd
	echo '#!/bin/sh' > ftpd/run
	echo 'exec tcpsvd -vE 0.0.0.0 8021 ftpd /data/data/com.magisk/files/home' >> ftpd/run
	echo '#!/bin/sh' > telnetd/run
	echo 'exec telnetd -F' >> telnetd/run
	chmod +x */run
}
