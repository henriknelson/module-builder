MAGISK_MODULE_HOMEPAGE=https://github.com/fenrus75/powertop
MAGISK_MODULE_DESCRIPTION="Debugging utility to monitor system calls and signals received"
MAGISK_MODULE_LICENSE="BSD"
MAGISK_MODULE_VERSION=2.12
MAGISK_MODULE_SRCURL=https://github.com/fenrus75/powertop/archive/v${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=35fbdbf2a02bf6f3558c013d83f4a0e96c2af9a29d0f764b843339f7c39bd1fb
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="--prefix=$MAGISK_PREFIX --mandir=$MAGISK_PREFIX/usr/share/man"
MAGISK_MODULE_DEPENDS="ncurses,libnl"
MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	LDFLAGS+=" -static"
	export PLATFORM=android
	aclocal --install -I m4 || true
	autoreconf -i -v || true
	#export ac_cv_file__usr_lib_kbd_consolefonts=no
	#export ac_cv_file__usr_share_consolefonts=no
	#export ac_cv_file__usr_lib_X11_fonts_misc=no
	#export ac_cv_file__usr_X11R6_lib_X11_fonts_misc=no
	return 0
	for i in $MAGISK_MODULE_SRCDIR/patches/android/*.patch ; do
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
