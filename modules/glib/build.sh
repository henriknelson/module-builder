MAGISK_MODULE_HOMEPAGE=https://developer.gnome.org/glib/
MAGISK_MODULE_DESCRIPTION="Library providing core building blocks for libraries and applications written in C"
MAGISK_MODULE_LICENSE="LGPL-2.1"
MAGISK_MODULE_VERSION=2.64.3
MAGISK_MODULE_SRCURL=https://ftp.gnome.org/pub/gnome/sources/glib/2.64/glib-2.64.3.tar.xz
MAGISK_MODULE_SHA256=fe9cbc97925d14c804935f067a3ad77ef55c0bbe9befe68962318f5a767ceb22
# libandroid-support to get langinfo.h in include path.
MAGISK_MODULE_DEPENDS="libffi, libiconv, pcre, libandroid-support, zlib"
MAGISK_MODULE_BREAKS="glib-dev"
MAGISK_MODULE_REPLACES="glib-dev"
MAGISK_MODULE_RM_AFTER_INSTALL="share/gtk-doc lib/locale share/glib-2.0/gettext share/gdb/auto-load share/glib-2.0/codegen share/glib-2.0/gdb bin/gtester-report bin/glib-gettextize bin/gdbus-codegen"
# Needed by pkg-config for glib-2.0:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
-Dlibmount=disabled
-Diconv=external
"

magisk_step_pre_configure() {
	# glib checks for __BIONIC__ instead of __ANDROID__:
	CFLAGS+=" -D__BIONIC__=1"
}

magisk_step_create_zipscripts() {
	for i in postinst postrm triggers; do
		sed \
			"s|@MAGISK_PREFIX@|${MAGISK_PREFIX}|g" \
			"${MAGISK_MODULE_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	chmod 644 ./triggers
}
