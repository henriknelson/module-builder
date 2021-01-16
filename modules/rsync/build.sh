MAGISK_MODULE_HOMEPAGE=https://rsync.samba.org/
MAGISK_MODULE_DESCRIPTION="Utility that provides fast incremental file transfer"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=3.2.3
MAGISK_MODULE_SRCURL=https://rsync.samba.org/ftp/rsync/src/rsync-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=becc3c504ceea499f4167a260040ccf4d9f2ef9499ad5683c179a697146ce50e
MAGISK_MODULE_DEPENDS="libiconv, liblz4, libpopt, openssh | dropbear, zlib, zstd"
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--with-rsyncd-conf=$MAGISK_PREFIX/etc/rsyncd.conf
--with-included-popt=no
--with-included-zlib=no
--disable-debug
--disable-simd
--disable-xattr-support
--disable-xxhash
"

magisk_step_pre_configure() {
	export LIBS=" -landroid-glob -llog"
}

mmagisk_step_configure() {
        echo "Configuring";
        ./configure $MAGISK_MODULE_EXTRA_CONFIGURE_ARGS \
        --prefix=$MAGISK_PREFIX \
        --host=$target_host \
        --target=$target_host \
        #CFLAGS=" -I$MAGISK_PREFIX/include -static $CFLAGS" \
        #LDFLAGS=" -L$MAGISK_PREFIX/lib -static $LDFLAGS" \
	LIBS=" -landroid-glob -llog";

        #[ ! "$(grep '^LDFLAGS += -Wl,--unresolved-symbols=ignore-in-object-files' src/local.mk)" ] && sed -i '1iLDFLAGS += -Wl,--unresolved-symbols=ignore-in-object-files' src/local.mk;
        #[ ! "$(grep '#define HAVE_MKFIFO 1' lib/config.h)" ] && echo "#define HAVE_MKFIFO 1" >> lib/config.h;
}
