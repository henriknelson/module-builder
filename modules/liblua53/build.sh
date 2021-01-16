MAGISK_MODULE_HOMEPAGE=https://www.lua.org/
MAGISK_MODULE_DESCRIPTION="Shared library for the Lua interpreter (v5.3.x)"
MAGISK_MODULE_LICENSE="MIT"
MAGISK_MODULE_VERSION=5.3.5
MAGISK_MODULE_REVISION=6
MAGISK_MODULE_SRCURL=https://www.lua.org/ftp/lua-${MAGISK_MODULE_VERSION}.tar.gz
MAGISK_MODULE_SHA256=0c2eed3f960446e1a3e4b9a1ca2f3ff893b6ce41942cf54d5dd59ab4b3b058ac
MAGISK_MODULE_EXTRA_MAKE_ARGS=linux
MAGISK_MODULE_BUILD_IN_SRC=true
MAGISK_MODULE_BREAKS="liblua-dev, liblua (<< 5.3.5-6)"
MAGISK_MODULE_REPLACES="liblua-dev, liblua (<< 5.3.5-6)"
MAGISK_MODULE_BUILD_DEPENDS="readline"

magisk_step_configure() {
	sed -e "s/%VER%/${MAGISK_MODULE_VERSION%.*}/g;s/%REL%/${MAGISK_MODULE_VERSION}/g" \
		-e "s|@MAGISK_PREFIX@|$MAGISK_PREFIX|" \
		"$MAGISK_MODULE_BUILDER_DIR"/lua.pc.in > lua.pc;
	echo  "bajs";
	cat "$MAGISK_MODULE_BUILDER_DIR/lua.pc.in";
	echo 'kiss'
	cat lua.pc
}

magisk_step_pre_configure() {
	AR+=" rcu"
	CFLAGS+=" -fPIC -DLUA_COMPAT_5_2 -DLUA_COMPAT_UNPACK"
	export MYLDFLAGS=$LDFLAGS
}

magisk_step_make() {
	make V=5.3 R=5.3.5;
}

magisk_step_make_install() {
	make \
		TO_BIN="lua5.3 luac5.3" \
		TO_LIB="liblua5.3.a liblua5.3.so liblua5.3.so.5.3 liblua5.3.so.${MAGISK_MODULE_VERSION}" \
		INSTALL_DATA="cp -d" \
		INSTALL_TOP="$MAGISK_PREFIX" \
		INSTALL_INC="$MAGISK_PREFIX/include/lua5.3" \
		INSTALL_MAN="$MAGISK_PREFIX/share/man/man1" \
		install
	install -Dm600 lua.pc "$MAGISK_PREFIX"/lib/pkgconfig/lua53.pc

	mv -f "$MAGISK_PREFIX"/share/man/man1/lua.1 "$MAGISK_PREFIX"/share/man/man1/lua5.3.1
	mv -f "$MAGISK_PREFIX"/share/man/man1/luac.1 "$MAGISK_PREFIX"/share/man/man1/luac5.3.1
}
