MAGISK_MODULE_HOMEPAGE=https://invisible-island.net/ncurses/
MAGISK_MODULE_DESCRIPTION="Library for text-based user interfaces in a terminal-independent manner"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=(6.1.20190511
		    9.22
		    15)
MAGISK_MODULE_REVISION=2
MAGISK_MODULE_SHA256=(fdbd39234fc7e7f8e5fd08d2329014e085fa5c8d0a9cc9a919e94bbc9d411c0e
		   e94628e9bcfa0adb1115d83649f898d6edb4baced44f5d5b769c2eeb8b95addd
		   3ae9ebef28aad081c6c11351f086776e2fd9547563b2f900732b41c376bec05a)
MAGISK_MODULE_SRCURL=(https://dl.bintray.com/termux/upstream/ncurses-${MAGISK_MODULE_VERSION:0:3}-${MAGISK_MODULE_VERSION:4}.tgz
		   https://fossies.org/linux/misc/rxvt-unicode-${MAGISK_MODULE_VERSION[1]}.tar.bz2
		   https://github.com/thestinger/termite/archive/v${MAGISK_MODULE_VERSION[2]}.tar.gz)

# --without-normal disables static libraries:
# --disable-stripping to disable -s argument to install which does not work when cross compiling:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_header_locale_h=no
--with-normal
--enable-static
--disable-stripping
--enable-const
--enable-ext-colors
--enable-ext-mouse
--enable-overwrite
--enable-pc-files
--enable-widec
--mandir=$MAGISK_PREFIX/usr/share/man
--without-ada
--without-cxx-binding
--without-debug
--without-tests
"
MAGISK_MODULE_INCLUDE_IN_DEVMODULE="
usr/share/man/man1/ncursesw6-config.1*
bin/ncursesw6-config
"
MAGISK_MODULE_RM_AFTER_INSTALL="
bin/captoinfo
bin/infotocap
usr/share/man/man1/captoinfo.1*
usr/share/man/man1/infotocap.1*
usr/share/man/man5
usr/share/man/man7
"
magisk_step_pre_configure() {
        MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --prefix=$MAGISK_PREFIX --datarootdir=$MAGISK_PREFIX/usr/share --host=aarch64-linux-android --with-pkg-config-libdir=$PKG_CONFIG_LIBDIR"
}

magisk_step_post_massage() {
	# Strip away 30 years of cruft to decrease size.
	local TI=$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX/usr/share/terminfo
	mv $TI $MAGISK_MODULE_TMPDIR/full-terminfo
	mkdir -p $TI/{a,d,e,n,l,p,r,s,t,v,x}
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/a/ansi $TI/a/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/d/{dtterm,dumb} $TI/d/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/e/eterm-color $TI/e/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/n/nsterm $TI/n/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/l/linux $TI/l/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/p/putty{,-256color} $TI/p/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/r/rxvt{,-256color} $TI/r/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/s/screen{,2,-256color} $TI/s/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/t/tmux{,-256color} $TI/t/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/v/{vt52,vt100,vt102} $TI/v/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/x/xterm{,-color,-new,-16color,-256color,+256color} $TI/x/

	tic -x -o $TI $MAGISK_MODULE_SRCDIR/rxvt-unicode-${MAGISK_MODULE_VERSION[1]}/doc/etc/rxvt-unicode.terminfo
	tic -x -o $TI $MAGISK_MODULE_SRCDIR/termite-${MAGISK_MODULE_VERSION[2]}/termite.terminfo
}
