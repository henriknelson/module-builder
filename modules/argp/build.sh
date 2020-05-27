MAGISK_MODULE_HOMEPAGE=https://www.lysator.liu.se/~nisse/misc/
MAGISK_MODULE_DESCRIPTION="Standalone version of arguments parsing functions from GLIBC"
MAGISK_MODULE_LICENSE="LGPL-2.0"
MAGISK_MODULE_VERSION=1.3
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://www.lysator.liu.se/~nisse/misc/argp-standalone-$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_SHA256=dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be
#MAGISK_MODULE_NO_STATICSPLIT=true
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --disable-dataroot --with-static --enable-static"

magisk_step_post_make_install() {
	cp libargp.a $MAGISK_PREFIX/lib
	cp $MAGISK_MODULE_SRCDIR/argp.h $MAGISK_PREFIX/include
}
