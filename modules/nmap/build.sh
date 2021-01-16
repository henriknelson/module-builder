MAGISK_MODULE_HOMEPAGE=https://nmap.org/
MAGISK_MODULE_DESCRIPTION="Utility for network discovery and security auditing"
MAGISK_MODULE_LICENSE="GPL-2.0"
MAGISK_MODULE_VERSION=7.91
MAGISK_MODULE_SRCURL=https://nmap.org/dist/nmap-${MAGISK_MODULE_VERSION}.tar.bz2
MAGISK_MODULE_SHA256=18cc4b5070511c51eb243cdd2b0b30ff9b2c4dc4544c6312f75ce3a67a593300
# Depend on netcat so that it gets installed automatically when installing
# nmap, since the ncat program is usually distributed as part of nmap.
MAGISK_MODULE_DEPENDS="libc++, libdl, libpcap, pcre, openssl, resolv-conf, liblua53, libssh2, zlib"
# --without-nmap-update to avoid linking against libsvn_client:
# --without-zenmap to avoid python scripts for graphical gtk frontend:
# --without-ndiff to avoid python2-using ndiff utility:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="
--enable-static
--with-liblua=$MAGISK_PREFIX/lib
--without-nmap-update
--without-zenmap
--without-ndiff
"

MAGISK_MODULE_BUILD_IN_SRC=true

magisk_step_pre_configure() {
	CXXFLAGS=" -static-libstdc++"
	export LIBS="-lz -ldl -lres"
}

magisk_step_make() {
         make -j4 static;
}

magisk_step_post_make_install() {
	# Setup 'netcat' and 'nc' as symlink to 'ncat', since the other netcat implementations
	# are outdated (gnu-netcat) or non-portable (openbsd-netcat).
	for prog in netcat nc; do
		cd $MAGISK_PREFIX/bin
		ln -s -f ncat $prog
		cd $MAGISK_PREFIX/usr/share/man/man1
		ln -s -f ncat.1 ${prog}.1
	done
}
