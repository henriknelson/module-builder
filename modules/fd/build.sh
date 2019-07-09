MAGISK_MODULE_HOMEPAGE=https://github.com/sharkdp/fd
MAGISK_MODULE_DESCRIPTION="Simple, fast and user-friendly alternative to find"
MAGISK_MODULE_LICENSE="Apache-2.0"
MAGISK_MODULE_VERSION=7.3.0
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SHA256=fbd48cc83c90a0ab09fc3bbe865708a3a528876a99f8304a17d07af7fb378170
MAGISK_MODULE_SRCURL=https://github.com/sharkdp/fd/archive/v$MAGISK_MODULE_VERSION.tar.gz
MAGISK_MODULE_BUILD_IN_SRC=yes


#magisk_step_patch_module() {
#	cd $MAGISK_MODULE_SRCDIR
#	echo "$MAGISK_MODULE_BUILDER_DIR"
#	for i in $MAGISK_MODULE_BUILDER_DIR/*.patch ; do
#    		PFILE=$(basename $i)
#		echo "PFILE=$PFILE"
#		cp -f $i $PFILE
#		echo $(pwd)
#		ls
#		patch -p0 -i $PFILE
#		[ $? -ne 0 ] && { echo "Patching failed! Did you verify line numbers? See README for more info"; exit 1; }
#		#rm -f $PFILE
 # 	done
#}

