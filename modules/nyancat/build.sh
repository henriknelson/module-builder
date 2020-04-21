MAGISK_MODULE_HOMEPAGE=http://nyancat.dakko.us
MAGISK_MODULE_DESCRIPTION="Nyancat in your terminal, rendered through ANSI escape sequences."
MAGISK_MODULE_LICENSE="NCSA"
MAGISK_MODULE_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
MAGISK_MODULE_VERSION=1.5.2
MAGISK_MODULE_SHA256=88cdcaa9c7134503dd0364a97fa860da3381a09cb555c3aae9918360827c2032
MAGISK_MODULE_SRCURL=https://github.com/klange/nyancat/archive/${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	LDFLAGS+=" --static"
}

mmagisk_step_post_configure() {
	cd $MAGISK_MODULE_BUILDDIR
	echo "$MAGISK_MODULE_BUILDER_DIR"
	for i in $MAGISK_MODULE_BUILDER_DIR/*.patch ; do
	PFILE=$(basename $i)
		echo "PFILE=$PFILE"
		cp -f $i $PFILE
		echo $(pwd)
		ls
		patch -p0 -i $PFILE
		[ $? -ne 0 ] && { echo "Patching failed! Did you verify line numbers? See README for more info"; exit 1; }
		#rm -f $PFILE
  	done
}
