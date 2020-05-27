MAGISK_MODULE_HOMEPAGE=http://tcl.sourceforge.net/
MAGISK_MODULE_DESCRIPTION="A windowing toolkit for use with tcl"
MAGISK_MODULE_LICENSE="custom"
MAGISK_MODULE_LICENSE_FILE="license.terms"
MAGISK_MODULE_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
MAGISK_MODULE_VERSION=8.6.10
MAGISK_MODULE_SRCURL=https://downloads.sourceforge.net/sourceforge/tcl/tk${MAGISK_MODULE_VERSION}-src.tar.gz
MAGISK_MODULE_SHA256=63df418a859d0a463347f95ded5cd88a3dd3aaa1ceecaeee362194bc30f3e386
MAGISK_MODULE_DEPENDS="fontconfig, libx11, libxft, libxss, tcl"
MAGISK_MODULE_NO_STATICSPLIT=true
MAGISK_MODULE_MAKE_INSTALL_TARGET="install install-private-headers"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS=" --enable-shared"


MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-threads
--enable-64bit
"

magisk_step_pre_configure() {
	MAGISK_MODULE_SRCDIR+="/unix"
	export LIBS=" -lX11-xcb"
}

magisk_step_post_make_install() {
	ln -sfr "$MAGISK_PREFIX/bin/wish${MAGISK_MODULE_VERSION:0:3}" \
		"$MAGISK_PREFIX"/bin/wish
	ln -sfr "$MAGISK_PREFIX/lib/libtk${MAGISK_MODULE_VERSION:0:3}.so" \
		"$MAGISK_PREFIX"/lib/libtk.so

	cd "$MAGISK_MODULE_SRCDIR"/../

	for dir in compat generic generic/ttk unix; do
		install -dm755 "$MAGISK_PREFIX/include/tk-private/$dir"
		install -m644 -t "$MAGISK_PREFIX/include/tk-private/$dir" "$dir"/*.h
	done
}
