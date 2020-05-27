MAGISK_MODULE_HOMEPAGE=https://www.gnu.org/software/make/
MAGISK_MODULE_DESCRIPTION="Tool to control the generation of non-source files from source files"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=4.3
MAGISK_MODULE_REVISION=1
MAGISK_MODULE_SRCURL=https://mirrors.kernel.org/gnu/make/make-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=e05fdde47c5f7ca45cb697e973894ff4f5d79e13b750ed57d7b66d8defc78e19
MAGISK_MODULE_BREAKS="make-dev"
MAGISK_MODULE_REPLACES="make-dev"
MAGISK_MODULE_DEPENDS="libandroid-spawn"
# Prevent linking against libelf:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="ac_cv_lib_elf_elf_begin=no"

magisk_step_pre_configure() {
    if [ "$MAGISK_ARCH" = arm ]; then
	# Fix issue with make on arm hanging at least under cmake:
	# https://github.com/termux/termux-packages/issues/2983
	MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_pselect=no"
    fi
    CFLAGS+=" -static -O2"
    LDFLAGS+=" -static"
}

magisk_step_make() {
	# Allow to bootstrap make if building on device without make installed.
	#if $MAGISK_ON_DEVICE_BUILD && [ -z "$(command -v make)" ]; then
	#	./build.sh
	#else
	make -j $MAGISK_MAKE_PROCESSES
	#fi
}

magisk_step_make_install() {
	#if $MAGISK_ON_DEVICE_BUILD && [ -z "$(command -v make)" ]; then
	#	./make -j 1 install
	#else
	make -j 1 install
	#fi
}
