MAGISK_MODULE_HOMEPAGE=https://www.ruby-lang.org/
MAGISK_MODULE_DESCRIPTION="Dynamic programming language with a focus on simplicity and productivity"
MAGISK_MODULE_LICENSE="BSD 2-Clause"
MAGISK_MODULE_VERSION=2.7.2
MAGISK_MODULE_SRCURL=https://cache.ruby-lang.org/pub/ruby/${MAGISK_MODULE_VERSION:0:3}/ruby-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=1b95ab193cc8f5b5e59d2686cb3d5dcf1ddf2a86cb6950e0b4bdaae5040ec0d6
# libbffi is used by the fiddle extension module:
MAGISK_MODULE_DEPENDS="gdbm, libandroid-support, libffi, libgmp, readline, openssl, libyaml, zlib"
MAGISK_MODULE_BREAKS="ruby-dev"
MAGISK_MODULE_REPLACES="ruby-dev"
# Needed to fix compilation on android:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="ac_cv_func_setgroups=no ac_cv_func_setresuid=no ac_cv_func_setreuid=no --enable-rubygems --with-coroutine=copy"
# The gdbm module seems to be very little used:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --without-gdbm"
# Do not link in libcrypt.so if available (now in disabled-packages):
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"
# Fix DEPRECATED_TYPE macro clang compatibility:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" rb_cv_type_deprecated=x"
# getresuid(2) does not work on ChromeOS - https://github.com/termux/termux-app/issues/147:
# MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_getresuid=no"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --prefix=/data/ruby --libdir=/data/ruby/lib --libexecdir=/data/ruby/libexec --disable-rpath --disable-rpath-hack rb_cv_type_deprecated=x --disable-nls --enable-static --enable-shared host_alias=aarch64-linux-android --disable-install-doc"
MAGISK_MODULE_HOSTBUILD=true

magisk_step_host_build() {
	"$MAGISK_MODULE_SRCDIR/configure" --prefix=$MAGISK_MODULE_HOSTBUILD_DIR/ruby-host
	make -j $MAGISK_MAKE_PROCESSES
	make install
	export PATH=$MAGISK_MODULE_HOSTBUILD_DIR/ruby-host/bin:$PATH
}

magisk_step_pre_configure() {
	export LDFLAGS=" -L/system/lib -Wl,-rpath=/data/ruby/lib -Wl,--enable-new-dtags -Wl,--as-needed -Wl,-z,relro,-z,now -landroid-support";
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
	make install

	local RBCONFIG=/data/ruby/lib/ruby/${MAGISK_MODULE_VERSION:0:3}.0/${MAGISK_HOST_PLATFORM}/rbconfig.rb

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
	cp -r /data/ruby $MAGISK_MODULE_MASSAGEDIR/data/
	if [ ! -f /data/ruby/lib/ruby/${MAGISK_MODULE_VERSION:0:3}.0/${MAGISK_HOST_PLATFORM}/readline.so ]; then
		echo "Error: The readline extension was not built"
	fi
}
