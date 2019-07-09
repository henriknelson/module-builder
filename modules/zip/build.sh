MAGISK_MODULE_HOMEPAGE=http://www.info-zip.org/
MAGISK_MODULE_DESCRIPTION="Tools for working with zip files"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=3.0
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SRCURL=https://downloads.sourceforge.net/infozip/zip30.tar.gz
MAGISK_MODULE_SHA256=f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369
#MAGISK_MODULE_DEPENDS="libandroid-support, libbz2"
MAGISK_MODULE_BUILD_IN_SRC=yes

magisk_step_make() {
        cd $MAGISK_MODULE_SRCDIR
        make -f unix/Makefile generic -j $(nproc) CC="$CC"
     	mkdir $MAGISK_MODULE_MASSAGEDIR/bin
	cp $MAGISK_MODULE_SRCDIR/zip $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/zip
}

magisk_step_make_install() {
	return
}

