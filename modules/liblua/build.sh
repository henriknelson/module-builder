MAGISK_MODULE_HOMEPAGE=https://www.lua.org/
MAGISK_MODULE_DESCRIPTION="Shared library for the Lua interpreter"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=5.3.5
MAGISK_MODULE_REVISION=4
MAGISK_MODULE_SHA256=0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac
MAGISK_MODULE_SRCURL=https://www.lua.org/ftp/lua-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_EXTRA_MAKE_ARGS=linux
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_BREAKS="liblua-dev"
MAGISK_MODULE_REPLACES="liblua-dev"
MAGISK_MODULE_BUILD_DEPENDS="readline"

magisk_step_pre_configure() {
	AR+=" rcu"
	CFLAGS+=" -fPIC -DLUA_COMPAT_5_2 -DLUA_COMPAT_UNPACK"
	export MYLDFLAGS=" -lncurses $LDFLAGS"
}

magisk_step_post_make_install() {
	# Add a pkg-config file for the system zlib
	cat > "$PKG_CONFIG_LIBDIR/lua.pc" <<-HERE
		Name: Lua
		Description: An Extensible Extension Language
		Version: $MAGISK_MODULE_VERSION
		Requires:
		Libs: -llua -lm
	HERE
}
