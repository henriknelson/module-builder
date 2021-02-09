MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/bash/
MAGISK_MODULE_DESCRIPTION="The command line version of Bredbandskollen CLI, a bandwidth measurement tool"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SHA256=88b26fb00dfd6182427ef79512129310cccdd2ec45c1a133c5859dfb60985d2a
MAGISK_MODULE_VERSION=1.1
MAGISK_MODULE_SRCURL=https://github.com/dotse/bbk/archive/master.zip
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_ESSENTIAL=false

magisk_step_make() {
  cd $MAGISK_MODULE_SRCDIR/src/cli
  mkdir -p $MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin
  make clean
  make -j $(nproc) CXX=$CXX TARGET=$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/bin/bbk_cli STATIC=2 LOGLEVEL=dbg
}

