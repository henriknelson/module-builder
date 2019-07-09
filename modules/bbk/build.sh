MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/bash/
MAGISK_MODULE_DESCRIPTION="The command line version of Bredbandskollen CLI, a bandwidth measurement tool"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SHA256=cb9c6f017853c40eaef5383bfc662fddede60dd8d4d84c3ab694c98e9be7c496
MAGISK_MODULE_VERSION=1.1
MAGISK_MODULE_SRCURL=https://github.com/dotse/bbk/archive/master.zip
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_ESSENTIAL=false

magisk_step_make() {
  cd $MAGISK_MODULE_SRCDIR/src/cli
  mkdir $MAGISK_MODULE_MASSAGEDIR/bin
  make clean
  make -j $(nproc) CXX=$CXX TARGET=$MAGISK_MODULE_MASSAGEDIR/bin/bbk_cli STATIC=2 LOGLEVEL=dbg
}


magisk_step_make_install() {
	return
}
