MAGISK_MODULE_HOMEPAGE=http://www.ltrace.org/
MAGISK_MODULE_DESCRIPTION="Tracks runtime library calls in dynamically linked programs"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=1:0.7.3
MAGISK_MODULE_SRCURL=https://github.com/dkogan/ltrace/archive/82c66409c7a93ca6ad2e4563ef030dfb7e6df4d4.tar.gz
MAGISK_MODULE_SHA256=4aecf69e4a33331aed1e50ce4907e73a98cbccc4835febc3473863474304d547
MAGISK_MODULE_DEPENDS="libc++, libelf"
MAGISK_MODULE_BUILD_IN_SRC=true

MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+="
--enable-static
--disable-shared
--disable-werror
--with-static
--without-shared
--without-libunwind
--without-libtool
ac_cv_host=aarch64-generic-linux-gnu
"

magisk_step_pre_configure() {
	make clean
	if [ "$MAGISK_ARCH" == "arm" ]; then
		CFLAGS+=" -DSHT_ARM_ATTRIBUTES=0x70000000+3"
	fi
	export CFLAGS+=" -static -static-libgcc -static"
	export LDFLAGS+=" -lstdc++ -lelf -lc++_static -lz -lc -static"
	LIBS=" -lc++_static -lelf -lc -ldl"
	autoreconf -i ../src
}
