MAGISK_MODULE_HOMEPAGE=https://mosh.org
MAGISK_MODULE_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
MAGISK_MODULE_LICENSE="GPL-3.0"
MAGISK_MODULE_VERSION=1.3.2
MAGISK_MODULE_REVISION=21
MAGISK_MODULE_SRCURL=https://github.com/mobile-shell/mosh/releases/download/mosh-${MAGISK_MODULE_VERSION}/mosh-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216
MAGISK_MODULE_DEPENDS="libandroid-support, libc++, libprotobuf, ncurses, openssl, openssh"
MAGISK_MODULE_EXTRA_CONFIGURATION_ARGS="
--static
--prefix=$MAGISK_PREFIX
"


magisk_step_pre_configure() {
	magisk_setup_protobuf
	ldflags_zlib=`pkg-config --libs-only-L zlib`
	LDFLAGS="${ldflags_zlib} -static"
}

magisk_step_post_make_install() {
	cd $MAGISK_PREFIX/bin
	mv mosh mosh.pl
	$CXX $CXXFLAGS $LDFLAGS \
		-isystem $MAGISK_PREFIX/include \
		-DPACKAGE_VERSION=\"$MAGISK_MODULE_VERSION\" \
		-std=c++11 -Wall -Wextra -Werror \
		$MAGISK_MODULE_BUILDER_DIR/mosh.cc -o mosh
}
