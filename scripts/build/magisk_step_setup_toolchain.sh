magisk_step_setup_toolchain() {
	if test -f Cargo.toml; then
		magisk_log "setting up rust toolchain.."
		export MUSL_PATH=/usr/local/musl
		export PATH=$MUSL_PATH/bin:$PATH
		export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_LINKER=aarch64-linux-musl-gcc
		export CC_aarch64_unknown_linux_musl=aarch64-linux-musl-gcc
		export CXX_aarch64_unknown_linux_musl=aarch64-linux-musl-g++
		export OPENSSL_DIR=/openssl
		export OPENSSL_INCLUDE_DIR=/openssl/include
		export OPENSSL_LIB_DIR=/openssl/lib

		export MUSL_BIN="$MUSL_PATH/bin/aarch64-linux-musl"

		export AS=${MUSL_BIN}-as
		export CC=$MUSL_BIN-gcc
		export CXX=$MUSL_BIN-c++

		export AR=$MUSL_BIN-ar
		export CPP=${MUSL_BIN}-cpp
		export CC_FOR_BUILD=gcc
		export LD=$MUSL_BIN-ld
		export OBJCOPY=$MUSL_BIN-objcopy
		export OBJDUMP=$MUSL_BIN-objdump
		# Setup pkg-config for cross-compiling:
		export PKG_CONFIG=$MAGISK_STANDALONE_TOOLCHAIN/bin/${MAGISK_HOST_PLATFORM}-pkg-config
		export RANLIB=$MUSL_BIN-ranlib
		export READELF=$MUSL_BIN-readelf
		export STRIP=$MUSL_BIN-strip
		export CFLAGS=""
		export LDFLAGS="-L${MAGISK_PREFIX}/lib"
	else
		magisk_log "setting up clang toolchain"
		export PATH=$MAGISK_STANDALONE_TOOLCHAIN/bin:$PATH

		export CFLAGS=""
		export LDFLAGS="-L${MAGISK_PREFIX}/lib"

		export AS=${MAGISK_HOST_PLATFORM}-clang
		export CC=$MAGISK_HOST_PLATFORM-clang
		export CXX=$MAGISK_HOST_PLATFORM-clang++

		export CCMAGISK_HOST_PLATFORM=$MAGISK_HOST_PLATFORM$MAGISK_MODULE_API_LEVEL
		if [ $MAGISK_ARCH = arm ]; then
	       		CCMAGISK_HOST_PLATFORM=armv7a-linux-androideabi$MAGISK_MODULE_API_LEVEL
		fi
		export AR=$MAGISK_HOST_PLATFORM-ar
		export CPP=${MAGISK_HOST_PLATFORM}-cpp
		export CC_FOR_BUILD=gcc
		export LD=$MAGISK_HOST_PLATFORM-ld
		export OBJCOPY=$MAGISK_HOST_PLATFORM-objcopy
		export OBJDUMP=$MAGISK_HOST_PLATFORM-objdump
		# Setup pkg-config for cross-compiling:
		export PKG_CONFIG=$MAGISK_STANDALONE_TOOLCHAIN/bin/${MAGISK_HOST_PLATFORM}-pkg-config
		export RANLIB=$MAGISK_HOST_PLATFORM-ranlib
		export READELF=$MAGISK_HOST_PLATFORM-readelf
		export STRIP=$MAGISK_HOST_PLATFORM-strip

	fi
		# Android 7 started to support DT_RUNPATH (but not DT_RPATH).
		LDFLAGS+=" -Wl,-rpath=$MAGISK_PREFIX/lib -Wl,--enable-new-dtags"

		if [ "$MAGISK_ARCH" = "arm" ]; then
			# https://developer.android.com/ndk/guides/standalone_toolchain.html#abi_compatibility:
			# "We recommend using the -mthumb compiler flag to force the generation of 16-bit Thumb-2 instructions".
			# With r13 of the ndk ruby 2.4.0 segfaults when built on arm with clang without -mthumb.
			CFLAGS+=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb"
			LDFLAGS+=" -march=armv7-a"
		elif [ "$MAGISK_ARCH" = "i686" ]; then
			# From $NDK/docs/CPU-ARCH-ABIS.html:
			CFLAGS+=" -march=i686 -msse3 -mstackrealign -mfpmath=sse"
		elif [ "$MAGISK_ARCH" = "aarch64" ]; then
			:
		elif [ "$MAGISK_ARCH" = "x86_64" ]; then
			:
		else
			magisk_error_exit "Invalid arch '$MAGISK_ARCH' - support arches are 'arm', 'i686', 'aarch64', 'x86_64'"
		fi

		if [ -n "$MAGISK_DEBUG" ]; then
			CFLAGS+=" -g3 -O1 -fstack-protector --param ssp-buffer-size=4 -D_FORTIFY_SOURCE=2"
		else
			if [ $MAGISK_ARCH = arm ]; then
				CFLAGS+=" -Os"
			else
				CFLAGS+=" -O0"
			fi
		fi

		export CXXFLAGS="$CFLAGS"
		export CPPFLAGS="-I${MAGISK_PREFIX}/include"

		# If libandroid-support is declared as a dependency, link to it explicitly:
		if [ "$MAGISK_MODULE_DEPENDS" != "${MAGISK_MODULE_DEPENDS/libandroid-support/}" ]; then
			LDFLAGS+=" -landroid-support"
		fi


		if [ "$MAGISK_MODULE_DEPENDS" != "${MAGISK_MODULE_DEPENDS/libcurl/}" ]; then
			LDFLAGS+=" -lcurl"
		fi

		export ac_cv_func_getpwent=no
		export ac_cv_func_getpwnam=no
		export ac_cv_func_getpwuid=no
		export ac_cv_func_sigsetmask=no
		export ac_cv_c_bigendian=no

		if [ ! -d $MAGISK_STANDALONE_TOOLCHAIN ]; then
			# Do not put toolchain in place until we are done with setup, to avoid having a half setup
			# toolchain left in place if something goes wrong (or process is just aborted):
			local _MAGISK_TOOLCHAIN_TMPDIR=${MAGISK_STANDALONE_TOOLCHAIN}-tmp
			rm -Rf $_MAGISK_TOOLCHAIN_TMPDIR
			local _NDK_ARCHNAME=$MAGISK_ARCH
			if [ "$MAGISK_ARCH" = "aarch64" ]; then
				_NDK_ARCHNAME=arm64
			elif [ "$MAGISK_ARCH" = "i686" ]; then
				_NDK_ARCHNAME=x86
			fi
			cp $NDK/toolchains/llvm/prebuilt/linux-x86_64 $_MAGISK_TOOLCHAIN_TMPDIR -r

			# Remove android-support header wrapping not needed on android-21:
			rm -Rf $_MAGISK_TOOLCHAIN_TMPDIR/sysroot/usr/local

			# Use gold by default to work around https://github.com/android-ndk/ndk/issues/148
			cp $_MAGISK_TOOLCHAIN_TMPDIR/bin/aarch64-linux-android-ld.gold \
			    $_MAGISK_TOOLCHAIN_TMPDIR/bin/aarch64-linux-android-ld
			cp $_MAGISK_TOOLCHAIN_TMPDIR/aarch64-linux-android/bin/ld.gold \
			    $_MAGISK_TOOLCHAIN_TMPDIR/aarch64-linux-android/bin/ld

				# Linker wrapper script to add '--exclude-libs libgcc.a', see
				# https://github.com/android-ndk/ndk/issues/379
				# https://android-review.googlesource.com/#/c/389852/
				local linker
				for linker in ld ld.bfd ld.gold; do
					local wrap_linker=$_MAGISK_TOOLCHAIN_TMPDIR/arm-linux-androideabi/bin/$linker
					local real_linker=$_MAGISK_TOOLCHAIN_TMPDIR/arm-linux-androideabi/bin/$linker.real
					cp $wrap_linker $real_linker
					echo '#!/bin/bash' > $wrap_linker
					echo -n '$(dirname $0)/' >> $wrap_linker
					echo -n $linker.real >> $wrap_linker
					echo ' --exclude-libs libunwind.a --exclude-libs libgcc_real.a "$@"' >> $wrap_linker
				done
			for HOST_PLAT in aarch64-linux-android armv7a-linux-androideabi i686-linux-android x86_64-linux-android; do

			# Setup the cpp preprocessor:
			cp $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT$MAGISK_MODULE_API_LEVEL-clang \
			   $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang
			cp $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT$MAGISK_MODULE_API_LEVEL-clang++ \
			   $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang++
			cp $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT$MAGISK_MODULE_API_LEVEL-clang \
			   $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-cpp
			sed -i 's/clang/clang -E/' \
			   $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-cpp
			cp $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang \
			   $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-gcc
			cp $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-clang++ \
			   $_MAGISK_TOOLCHAIN_TMPDIR/bin/$HOST_PLAT-gcc
			done
			cp $_MAGISK_TOOLCHAIN_TMPDIR/bin/armv7a-linux-androideabi$MAGISK_MODULE_API_LEVEL-clang \
			   $_MAGISK_TOOLCHAIN_TMPDIR/bin/arm-linux-androideabi-clang
			cp $_MAGISK_TOOLCHAIN_TMPDIR/bin/armv7a-linux-androideabi$MAGISK_MODULE_API_LEVEL-clang++ \
			   $_MAGISK_TOOLCHAIN_TMPDIR/bin/arm-linux-androideabi-clang++
			cp $_MAGISK_TOOLCHAIN_TMPDIR/bin/armv7a-linux-androideabi-cpp \
			   $_MAGISK_TOOLCHAIN_TMPDIR/bin/arm-linux-androideabi-cpp

			cd $_MAGISK_TOOLCHAIN_TMPDIR/sysroot
			for f in $MAGISK_SCRIPTDIR/ndk-patches/*.patch; do
				sed "s%\@MAGISK_PREFIX\@%${MAGISK_PREFIX}%g" "$f" | \
					sed "s%\@MAGISK_HOME\@%${MAGISK_ANDROID_HOME}%g" | \
					patch --silent -p1;
			done
			# ifaddrs.h: Added in android-24 unified headers, use a inline implementation for now.
			# libintl.h: Inline implementation gettext functions.
			# langinfo.h: Inline implementation of nl_langinfo().
			cp "$MAGISK_SCRIPTDIR"/ndk-patches/{ifaddrs.h,libintl.h,langinfo.h} usr/include

			# Remove <sys/capability.h> because it is provided by libcap-dev.
			# Remove <sys/shm.h> from the NDK in favour of that from the libandroid-shmem.
			# Remove <sys/sem.h> as it doesn't work for non-root.
			# Remove <glob.h> as we currently provide it from libandroid-glob.
			# Remove <iconv.h> as it's provided by libiconv.
			# Remove <spawn.h> as it's only for future (later than android-27).
			# Remove <zlib.h> and <zconf.h> as we build our own zlib
			rm usr/include/sys/{capability.h,shm.h,sem.h} usr/include/{glob.h,iconv.h,spawn.h,zlib.h,zconf.h}

			sed -i "s/define __ANDROID_API__ __ANDROID_API_FUTURE__/define __ANDROID_API__ $MAGISK_MODULE_API_LEVEL/" \
				usr/include/android/api-level.h

			#$MAGISK_ELF_CLEANER usr/lib/*/*/*.so

			grep -lrw $_MAGISK_TOOLCHAIN_TMPDIR/sysroot/usr/include/c++/v1 -e '<version>'   | xargs -n 1 sed -i 's/<version>/\"version\"/g'
			mv $_MAGISK_TOOLCHAIN_TMPDIR $MAGISK_STANDALONE_TOOLCHAIN
		fi

		# On Android 7, libutil functionality is provided by libc.
		# But many programs still may search for libutil.
		if [ ! -f $MAGISK_PREFIX/lib/libutil.so ]; then
			mkdir -p "$MAGISK_PREFIX/lib"
			echo 'INPUT(-lc)' > $MAGISK_PREFIX/lib/libutil.so
		fi

		export PKG_CONFIG_LIBDIR="$MAGISK_MODULE_CONFIG_LIBDIR"
		# Create a pkg-config wrapper. We use path to host pkg-config to
		# avoid picking up a cross-compiled pkg-config later on.
		local _HOST_PKGCONFIG
		_HOST_PKGCONFIG=$(which pkg-config)
		mkdir -p $MAGISK_STANDALONE_TOOLCHAIN/bin "$PKG_CONFIG_LIBDIR"
		cat > "$PKG_CONFIG" <<-HERE
			#!/bin/sh
			export PKG_CONFIG_DIR=
			export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR
			exec $_HOST_PKGCONFIG "\$@"
		HERE
		chmod +x "$PKG_CONFIG"
}

