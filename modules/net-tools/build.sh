MAGISK_MODULE_HOMEPAGE=http://net-tools.sourceforge.net/
MAGISK_MODULE_DESCRIPTION="Configuration tools for Linux networking"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=1.60.2017.02.21
MAGISK_MODULE_REVISION=2
local commit=479bb4a7e11a4084e2935c0a576388f92469225b
MAGISK_MODULE_SHA256=7e9f8e8dcbabed0c8eeb976100496567abae7ac9d92c72cebd1a9d965473e943
# We use a mirror to avoid using
# https://sourceforge.net/code-snapshots/git/n/ne/net-tools/code.git/net-tools-code-$commit.zip
# which does not work all the time (sourceforge caching system):
MAGISK_MODULE_SRCURL=https://dl.bintray.com/termux/upstream/net-tools-code-${commit}.zip
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_EXTRA_MAKE_ARGS="BINDIR=$MAGISK_PREFIX/bin SBINDIR=$MAGISK_PREFIX/bin HAVE_HOSTNAME_TOOLS=0"

magisk_step_configure() {
	CFLAGS="$CFLAGS -D_LINUX_IN6_H -Dindex=strchr -Drindex=strrchr"
	LDFLAGS="$LDFLAGS -llog"
	sed -i "s#/usr#$MAGISK_PREFIX#" $MAGISK_MODULE_SRCDIR/man/Makefile
	yes "" | make config || true
}

magisk_step_make_install() {
	make $MAGISK_MODULE_EXTRA_MAKE_ARGS update
}
