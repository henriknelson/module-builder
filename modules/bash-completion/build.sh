MAGISK_MODULE_HOMEPAGE=https://github.com/scop/bash-completion
MAGISK_MODULE_DESCRIPTION="Programmable completion for the bash shell"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=2.9
MAGISK_MODULE_SHA256=d48fe378e731062f479c5f8802ffa9d3c40a275a19e6e0f6f6cc4b90fa12b2f5
MAGISK_MODULE_SRCURL=https://github.com/scop/bash-completion/releases/download/${MAGISK_MODULE_VERSION}/bash-completion-${MAGISK_MODULE_VERSION}.tar.xz
#MAGISK_MODULE_DEPENDS="bash"
MAGISK_MODULE_PLATFORM_INDEPENDENT=yes
MAGISK_MODULE_BUILD_IN_SRC=yes

#MAGISK_MODULE_ESSENTIAL=yes

magisk_step_configure() {
	#MUSL=/usr/local/musl/bin
	#TARGET=aarch64-linux-musl
	#export CC=$MUSL/$TARGET-gcc
	#export LD=$MUSL/$TARGET-ld
	autoreconf -i
	./configure --prefix=$MAGISK_PREFIX --host=aarch64-linux-android 
}

magisk_step_make_make() {
	make
	return
	_C_FILES="src/musl-*/*.c"
	#CFLAGS="$CFLAGS -static"
	#LDFLAGS=" --static"
	#$CC $CFLAGS -std=c99 -DNULL=0 $CPPFLAGS $LDFLAGS \
	#	-Iinclude \
	#	$_C_FILES \
	#	-shared -fPIC \
	#	-o $MAGISK_PREFIX/lib/libandroid-support.so
	printenv
	$CC -static -Iinclude -I$MAGISK_PREFIX/include -L$MAGISK_PREFIX/lib $_C_FILES -shared -fPIC -o $MAGISK_PREFIX/lib/libandroid-support.a
}

magisk_step_make_install() {
	make install
}
