MAGISK_MODULE_HOMEPAGE=https://invisible-island.net/ncurses/
MAGISK_MODULE_DESCRIPTION="Library for text-based user interfaces in a terminal-independent manner"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=(6.2.20200725
		    9.22
		    15)
MAGISK_MODULE_SRCURL=(https://dl.bintray.com/termux/upstream/ncurses-${MAGISK_MODULE_VERSION:0:3}-${MAGISK_MODULE_VERSION:4}.tgz
		   https://fossies.org/linux/misc/rxvt-unicode-${MAGISK_MODULE_VERSION[1]}.tar.bz2
		   https://github.com/thestinger/termite/archive/v${MAGISK_MODULE_VERSION[2]}.tar.gz)
MAGISK_MODULE_SHA256=(05da39f964643b595bfdb874e52eabfd407c02d8fbed35602040735f4af9b09d
		   e94628e9bcfa0adb1115d83649f898d6edb4baced44f5d5b769c2eeb8b95addd
		   3ae9ebef28aad081c6c11351f086776e2fd9547563b2f900732b41c376bec05a)
# ncurses-utils: tset/reset/clear are moved to package 'ncurses'.
MAGISK_MODULE_BREAKS="ncurses-dev, ncurses-utils (<< 6.1.20190511-4)"
MAGISK_MODULE_REPLACES="ncurses-dev, ncurses-utils (<< 6.1.20190511-4)"

# --disable-stripping to disable -s argument to install which does not work when cross compiling:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
ac_cv_header_locale_h=no
--disable-stripping
--enable-const
--enable-ext-colors
--enable-ext-mouse
--enable-overwrite
--enable-pc-files
--enable-termcap
--enable-widec
--mandir=$MAGISK_PREFIX/usr/share/man
--without-ada
--without-cxx-binding
--without-debug
--without-tests
--with-normal
--with-static
--with-shared
--with-termpath=$MAGISK_PREFIX/etc/termcap:$MAGISK_PREFIX/usr/share/termcap
"


magisk_step_pre_configure() {
	MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --prefix=$MAGISK_PREFIX --datarootdir=$MAGISK_PREFIX/usr/share --with-pkg-config-libdir=$PKG_CONFIG_LIBDIR"
	export TERMINFO=$MAGISK_PREFIX/usr/share/terminfo
}

magisk_step_post_make_install() {
	cd $MAGISK_PREFIX/lib

	# Ncursesw/Ncurses compatibility
	# symlinks.
	for lib in form menu ncurses panel; do
		ln -sfr lib${lib}w.so.${MAGISK_MODULE_VERSION:0:3} lib${lib}.so.${MAGISK_MODULE_VERSION:0:3}
		ln -sfr lib${lib}w.so.${MAGISK_MODULE_VERSION:0:3} lib${lib}.so.${MAGISK_MODULE_VERSION:0:1}
		ln -sfr lib${lib}w.so.${MAGISK_MODULE_VERSION:0:3} lib${lib}.so
		ln -sfr lib${lib}w.a lib${lib}.a
		(cd pkgconfig; ln -sf ${lib}w.pc $lib.pc)
	done

	# Legacy compatibility symlinks (libcurses, libtermcap, libtic, libtinfo).
	for lib in curses termcap tic tinfo; do
		ln -sfr libncursesw.so.${MAGISK_MODULE_VERSION:0:3} lib${lib}.so.${MAGISK_MODULE_VERSION:0:3}
		ln -sfr libncursesw.so.${MAGISK_MODULE_VERSION:0:3} lib${lib}.so.${MAGISK_MODULE_VERSION:0:1}
		ln -sfr libncursesw.so.${MAGISK_MODULE_VERSION:0:3} lib${lib}.so
		ln -sfr libncursesw.a lib${lib}.a
		(cd pkgconfig; ln -sfr ncursesw.pc ${lib}.pc)
	done

	# Some packages want these:
	cd $MAGISK_PREFIX/include
	rm -Rf ncurses{,w}
	mkdir ncurses{,w}
	ln -s ../{ncurses.h,termcap.h,panel.h,unctrl.h,menu.h,form.h,tic.h,nc_tparm.h,term.h,eti.h,term_entry.h,ncurses_dll.h,curses.h} ncurses
	ln -s ../{ncurses.h,termcap.h,panel.h,unctrl.h,menu.h,form.h,tic.h,nc_tparm.h,term.h,eti.h,term_entry.h,ncurses_dll.h,curses.h} ncursesw
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
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/s/{screen{,2,-256color},st{,-256color}} $TI/s/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/t/tmux{,-256color} $TI/t/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/v/{vt52,vt100,vt102} $TI/v/
	cp $MAGISK_MODULE_TMPDIR/full-terminfo/x/xterm{,-color,-new,-16color,-256color,+256color} $TI/x/

	tic -x -o $TI $MAGISK_MODULE_SRCDIR/rxvt-unicode-${MAGISK_MODULE_VERSION[1]}/doc/etc/rxvt-unicode.terminfo
	tic -x -o $TI $MAGISK_MODULE_SRCDIR/termite-${MAGISK_MODULE_VERSION[2]}/termite.terminfo
}
