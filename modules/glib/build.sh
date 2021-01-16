MAGISK_MODULE_HOMEPAGE=https://developer.gnome.org/glib/
MAGISK_MODULE_DESCRIPTION="Library providing core building blocks for libraries and applications written in C"
MAGISK_MODULE_LICENSE="LGPL-2.1"
MAGISK_MODULE_VERSION=2.66.1
MAGISK_MODULE_SRCURL=https://ftp.gnome.org/pub/gnome/sources/glib/${MAGISK_MODULE_VERSION:0:4}/glib-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=a269ffe69fbcc3a21ff1acb1b6146b2a5723499d6e2de33ae16ccb6d2438ef60
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
