magisk_setup_meson() {
	magisk_setup_ninja
	local MESON_VERSION=0.50.1
	local MESON_FOLDER=$MAGISK_COMMON_CACHEDIR/meson-$MESON_VERSION-v1
	if [ ! -d "$MESON_FOLDER" ]; then
		local MESON_TAR_NAME=meson-$MESON_VERSION.tar.gz
		local MESON_TAR_FILE=$MAGISK_MODULE_TMPDIR/$MESON_TAR_NAME
		local MESON_TMP_FOLDER=$MAGISK_MODULE_TMPDIR/meson-$MESON_VERSION
		magisk_download \
			"https://github.com/mesonbuild/meson/releases/download/$MESON_VERSION/meson-$MESON_VERSION.tar.gz" \
			"$MESON_TAR_FILE" \
			f68f56d60c80a77df8fc08fa1016bc5831605d4717b622c96212573271e14ecc
		tar xf "$MESON_TAR_FILE" -C "$MAGISK_MODULE_TMPDIR"
		# Avoid meson stripping away DT_RUNPATH, see
		# (https://github.com/NetBSD/pkgsrc/commit/2fb2c013715a6374b4e2d1f8e9f2143e827f0f64
		# and https://github.com/mesonbuild/meson/issues/314):
		perl -p -i -e 's/self.fix_rpathtype_entry\(new_rpath, DT_RUNPATH\)//' \
			$MESON_TMP_FOLDER/mesonbuild/scripts/depfixer.py

		mv "$MESON_TMP_FOLDER" "$MESON_FOLDER"
	fi
	MAGISK_MESON="$MESON_FOLDER/meson.py"
	MAGISK_MESON_CROSSFILE=$MAGISK_MODULE_TMPDIR/meson-crossfile-$MAGISK_ARCH.txt
	local MESON_CPU MESON_CPU_FAMILY
	if [ "$MAGISK_ARCH" = "arm" ]; then
		MESON_CPU_FAMILY="arm"
		MESON_CPU="armv7"
	elif [ "$MAGISK_ARCH" = "i686" ]; then
		MESON_CPU_FAMILY="x86"
		MESON_CPU="i686"
	elif [ "$MAGISK_ARCH" = "x86_64" ]; then
		MESON_CPU_FAMILY="x86_64"
		MESON_CPU="x86_64"
	elif [ "$MAGISK_ARCH" = "aarch64" ]; then
		MESON_CPU_FAMILY="arm"
		MESON_CPU="aarch64"
	else
		magisk_error_exit "Unsupported arch: $MAGISK_ARCH"
	fi

	local CONTENT=""
	echo "[binaries]" > $MAGISK_MESON_CROSSFILE
	echo "ar = '$AR'" >> $MAGISK_MESON_CROSSFILE
	echo "c = '$CC'" >> $MAGISK_MESON_CROSSFILE
	echo "cpp = '$CXX'" >> $MAGISK_MESON_CROSSFILE
	echo "ld = '$LD'" >> $MAGISK_MESON_CROSSFILE
	echo "pkgconfig = '$PKG_CONFIG'" >> $MAGISK_MESON_CROSSFILE
	echo "strip = '$STRIP'" >> $MAGISK_MESON_CROSSFILE

	echo '' >> $MAGISK_MESON_CROSSFILE
	echo "[properties]" >> $MAGISK_MESON_CROSSFILE
	echo "needs_exe_wrapper = true" >> $MAGISK_MESON_CROSSFILE

	echo -n "c_args = [" >> $MAGISK_MESON_CROSSFILE
	local word first=true
	for word in $CFLAGS $CPPFLAGS; do
		if [ "$first" = "true" ]; then
			first=false
		else
			echo -n ", " >> $MAGISK_MESON_CROSSFILE
		fi
		echo -n "'$word'" >> $MAGISK_MESON_CROSSFILE
	done
	echo ']' >> $MAGISK_MESON_CROSSFILE

	echo -n "cpp_args = [" >> $MAGISK_MESON_CROSSFILE
	local word first=true
	for word in $CXXFLAGS $CPPFLAGS; do
		if [ "$first" = "true" ]; then
			first=false
		else
			echo -n ", " >> $MAGISK_MESON_CROSSFILE
		fi
		echo -n "'$word'" >> $MAGISK_MESON_CROSSFILE
	done
	echo ']' >> $MAGISK_MESON_CROSSFILE

	local property
	for property in c_link_args cpp_link_args; do
		echo -n "$property = [" >> $MAGISK_MESON_CROSSFILE
		first=true
		for word in $LDFLAGS; do
			if [ "$first" = "true" ]; then
				first=false
			else
				echo -n ", " >> $MAGISK_MESON_CROSSFILE
			fi
			echo -n "'$word'" >> $MAGISK_MESON_CROSSFILE
		done
		echo ']' >> $MAGISK_MESON_CROSSFILE
	done

	echo '' >> $MAGISK_MESON_CROSSFILE
	echo "[host_machine]" >> $MAGISK_MESON_CROSSFILE
	echo "cpu_family = '$MESON_CPU_FAMILY'" >> $MAGISK_MESON_CROSSFILE
	echo "cpu = '$MESON_CPU'" >> $MAGISK_MESON_CROSSFILE
	echo "endian = 'little'" >> $MAGISK_MESON_CROSSFILE
	echo "system = 'android'" >> $MAGISK_MESON_CROSSFILE
}
