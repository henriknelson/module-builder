MAGISK_MODULE_HOMEPAGE=http://python.org/
MAGISK_MODULE_DESCRIPTION="Python 2 programming language intended to enable clear programs"
MAGISK_MODULE_LICENSE="PythonPL"
# lib/python3.4/lib-dynload/_ctypes.cpython-34m.so links to ffi.
# openssl for ensurepip.
# libbz2 for the bz2 module.
# ncurses-ui-libs for the curses.panel module.
MAGISK_MODULE_DEPENDS="libandroid-support, ncurses, readline, libffi, openssl, libbz2, libsqlite, gdbm, ncurses-ui-libs, libcrypt, zlib"
MAGISK_MODULE_BREAKS="python2-dev"
MAGISK_MODULE_REPLACES="python2-dev"
# Python.h includes crypt.h:
MAGISK_MODULE_HOSTBUILD=true

_MAJOR_VERSION=2.7
MAGISK_MODULE_VERSION=${_MAJOR_VERSION}.18
MAGISK_MODULE_SRCURL=https://www.python.org/ftp/python/${MAGISK_MODULE_VERSION}/Python-${MAGISK_MODULE_VERSION}.tar.xz
MAGISK_MODULE_SHA256=b62c0e7937551d0cc02b8fd5cb0f544f9405bafc9a54d3808ed4594812edef43

# The flag --with(out)-pymalloc (disable/enable specialized mallocs) is enabled by default and causes m suffix versions of python.
# Set ac_cv_func_wcsftime=no to avoid errors such as "character U+ca0025 is not in range [U+0000; U+10ffff]"
# when executing e.g. "from time import time, strftime, localtime; print(strftime(str('%Y-%m-%d %H:%M'), localtime()))"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS="ac_cv_file__dev_ptmx=yes ac_cv_file__dev_ptc=no ac_cv_func_wcsftime=no"
# Avoid trying to include <sys/timeb.h> which does not exist on android-21:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_ftime=no"
# Avoid trying to use AT_EACCESS which is not defined:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_faccessat=no"
# The gethostbyname_r function does not exist on device libc:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_gethostbyname_r=no"
# Do not assume getaddrinfo is buggy when cross compiling:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_buggy_getaddrinfo=no"
# Fix https://github.com/termux/termux-packages/issues/2236:
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" ac_cv_little_endian_double=yes"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --build=$MAGISK_BUILD_TUPLE --with-system-ffi --without-ensurepip"
MAGISK_MODULE_EXTRA_CONFIGURE_ARGS+=" --enable-unicode=ucs4"
MAGISK_MODULE_RM_AFTER_INSTALL="
bin/smtpd.py
bin/python
bin/python-config
share/man/man1/python.1
bin/idle*
lib/python${_MAJOR_VERSION}/idlelib
lib/python${_MAJOR_VERSION}/lib-tk
lib/python${_MAJOR_VERSION}/test
lib/python${_MAJOR_VERSION}/*/test
lib/python${_MAJOR_VERSION}/*/tests
"

magisk_step_host_build() {
	# We need a host-built Parser/pgen binary, copied into cross-compile build in magisk_step_post_configure() below
	$MAGISK_MODULE_SRCDIR/configure
	make Parser/pgen
	# We need a python$_MAJOR_VERSION binary to be picked up by configure check:
	make
	rm -f python$_MAJOR_VERSION # Remove symlink if already exists to get a newer timestamp
	ln -s python python$_MAJOR_VERSION
}

magisk_step_post_configure() {
	cp $MAGISK_MODULE_HOSTBUILD_DIR/Parser/pgen $MAGISK_MODULE_BUILDDIR/Parser/pgen
	touch -d "next hour" $MAGISK_MODULE_BUILDDIR/Parser/pgen
}

magisk_step_pre_configure() {
	# Put the host-built python in path:
	export MAGISK_ORIG_PATH=$PATH
	export PATH=$MAGISK_MODULE_HOSTBUILD_DIR:$PATH

	# Needed when building with clang, as setup.py only probes
	# gcc for include paths when finding headers for determining
	# if extension modules should be built (specifically, the
	# zlib extension module is not built without this):
	CPPFLAGS+=" -I$MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/include"
	LDFLAGS+=" -L$MAGISK_STANDALONE_TOOLCHAIN/sysroot/usr/lib"
	if [ $MAGISK_ARCH = x86_64 ]; then LDFLAGS+=64; fi
}

magisk_step_post_make_install() {
	# Avoid file clashes with the python (3) package:
	(cd $MAGISK_PREFIX/bin
	 mv 2to3 2to3-${_MAJOR_VERSION}
	 mv pydoc pydoc${_MAJOR_VERSION}
	 ln -sf pydoc${_MAJOR_VERSION} pydoc2)
	# Restore path which magisk_step_host_build messed with
	export PATH=$MAGISK_ORIG_PATH
}

magisk_step_post_massage() {
	# Verify that desired modules have been included:
	for module in _ssl bz2 zlib _curses _sqlite3; do
		if [ ! -f lib/python${_MAJOR_VERSION}/lib-dynload/${module}.so ]; then
			magisk_error_exit "Python module library $module not built"
		fi
	done
}

mmagisk_step_create_zipscripts() {
	## POST INSTALL:
	echo "#!$MAGISK_PREFIX/bin/sh" > postinst
	echo "echo 'Setting up pip2...'" >> postinst
	# Fix historical mistake which removed bin/pip2 but left site-packages/pip-*.dist-info,
	# which causes ensurepip to avoid installing pip due to already existing pip install:
	echo "if [ ! -f $MAGISK_PREFIX/bin/pip2 -a -d $MAGISK_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/pip-*.dist-info ]; then rm -Rf $MAGISK_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/pip-*.dist-info ; fi" >> postinst
	# Setup bin/pip2:
	echo "$MAGISK_PREFIX/bin/python2 -m ensurepip --upgrade --no-default-pip" >> postinst

	## PRE RM:
	# Avoid running on update
	echo "#!$MAGISK_PREFIX/bin/sh" > prerm:
	echo 'if [ $1 != "remove" ]; then exit 0; fi' >> prerm
	# Uninstall everything installed through pip:
	echo "pip2 freeze 2> /dev/null | xargs pip2 uninstall -y > /dev/null 2> /dev/null" >> prerm
	# Cleanup *.pyc files
	echo "find $MAGISK_PREFIX/lib/python${_MAJOR_VERSION} -depth -name *.pyc -exec rm -rf {} +" >> prerm
	# Remove contents of site-packages/ folder:
	echo "rm -Rf $MAGISK_PREFIX/lib/python${_MAJOR_VERSION}/site-packages/*" >> prerm
	# Remove pip and easy_install installed by ensurepip in postinst:
	echo "rm -f $MAGISK_PREFIX/bin/pip2* $MAGISK_PREFIX/bin/easy_install-2*" >> prerm

	echo "exit 0" >> postinst
	echo "exit 0" >> prerm
	chmod 0755 postinst prerm
}
