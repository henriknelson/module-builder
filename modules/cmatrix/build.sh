MAGISK_MODULE_HOMEPAGE=https://github.com/abishekvashok/cmatrix
MAGISK_MODULE_DESCRIPTION="Command producing a Matrix-style animation"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=2.0
MAGISK_MODULE_SHA256=ad93ba39acd383696ab6a9ebbed1259ecf2d3cf9f49d6b97038c66f80749e99a
MAGISK_MODULE_SRCURL=https://github.com/abishekvashok/cmatrix/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--prefix=$MAGISK_PREFIX --mandir=$MAGISK_PREFIX/usr/share/man"
MAGISK_MODULE_DEPENDS="ncurses"

magisk_step_pre_configure() {
	autoreconf -i
	export ac_cv_file__usr_lib_kbd_consolefonts=no
	export ac_cv_file__usr_share_consolefonts=no
	export ac_cv_file__usr_lib_X11_fonts_misc=no
	export ac_cv_file__usr_X11R6_lib_X11_fonts_misc=no
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
