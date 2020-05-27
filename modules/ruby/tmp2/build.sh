MAGISK_MODULE_HOMEPAGE=https://www.ruby-lang.org/
MAGISK_MODULE_DESCRIPTION="Dynamic programming language with a focus on simplicity and productivity"
_MAJOR_VERSION=2.5
MAGISK_MODULE_VERSION=${_MAJOR_VERSION}.1
MAGISK_MODULE_SHA256=886ac5eed41e3b5fc699be837b0087a6a5a3d10f464087560d2d21b3e71b754d
MAGISK_MODULE_SRCURL=https://cache.ruby-lang.org/pub/ruby/${_MAJOR_VERSION}/ruby-${MAGISK_MODULE_VERSION}.tar.xz
# libbffi is used by the fiddle extension module:
MAGISK_MODULE_DEPENDS="libandroid-support, ncurses, libffi, libgmp, readline, openssl, libutil, libyaml"
# Needed to fix compilation on android:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="ac_cv_func_setgroups=no ac_cv_func_setresuid=no ac_cv_func_setreuid=no --enable-rubygems"
# The gdbm module seems to be very little used:
#MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --without-gdbm"
# Do not link in libcrypt.so if available (now in disabled-packages):
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"
# Fix DEPRECATED_TYPE macro clang compatibility:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" rb_cv_type_deprecated=x"
# getresuid(2) does not work on ChromeOS - https://github.com/termux/termux-app/issues/147:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --prefix=/data/ruby --libdir=/data/ruby/lib --disable-rpath --disable-rpath-hack rb_cv_type_deprecated=x --disable-nls --enable-shared --enable-static host_alias=aarch64-linux-android --with-yaml --with-readline-dir=`brew --prefix readline` --disable-install-doc"

magisk_step_pre_configure() {
	#export LD_LIBRARY_PATH="/system/lib"
	#MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --with-pkg-config=$PKG_CONFIG --with-pkg-config-libdir=$PKG_CONFIG_LIBDIR"
	#export CFLAGS=" -I/system/include -Oz";
	export LDFLAGS=" -L/system/lib -Wl,-rpath=/data/ruby/lib -Wl,--enable-new-dtags -Wl,--as-needed -Wl,-z,relro,-z,now -ledit -landroid-support -lyaml";
	#export CPPFLAGS=" -I/system/include";
	#export CXXFLAGS=" -I/system/include -Oz";
	#export LIBS=" -lreadline"
	sudo mkdir -p /data/ruby/;
	sudo mkdir -p /data/ruby/bin;
	sudo chown -R builder:builder /data/ruby;
	old=$(pwd);
	cd /data/ruby/bin;
	ln -sf /system/bin/sh sh;
	cd "$old";
}

magisk_step_make_install() {
	make install
	make uninstall # remove possible remains to get fresh timestamps
	#make update-gems;
	#make extract-gems;
	make install

	local RBCONFIG=/data/ruby/lib/ruby/${_MAJOR_VERSION}.0/${MAGISK_HOST_PLATFORM}/rbconfig.rb

	# Fix absolute paths to executables:
	perl -p -i -e 's/^.*CONFIG\["INSTALL"\].*$/  CONFIG["INSTALL"] = "install -c"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["PKG_CONFIG"\].*$/  CONFIG["PKG_CONFIG"] = "pkg-config"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["MAKEDIRS"\].*$/  CONFIG["MAKEDIRS"] = "mkdir -p"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["MKDIR_P"\].*$/  CONFIG["MKDIR_P"] = "mkdir -p"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["EGREP"\].*$/  CONFIG["EGREP"] = "grep -E"/' $RBCONFIG
	perl -p -i -e 's/^.*CONFIG\["GREP"\].*$/  CONFIG["GREP"] = "grep"/' $RBCONFIG
}

magisk_step_post_massage() {
	mkdir -p $MAGISK_MODULE_MASSAGEDIR/data
	cp -r /data/ruby $MAGISK_MODULE_MASSAGEDIR/data/;
	if [ ! -f /data/ruby/lib/ruby/${_MAJOR_VERSION}.0/${MAGISK_HOST_PLATFORM}/readline.so ]; then
		echo "Error: The readline extension was not built"
	fi
}
