magisk_create_submodules() {
	# Sub modules:
	if [ -d include ] && [ -z "${MAGISK_MODULE_NO_DEVELSPLIT}" ]; then
		# Add virtual -dev sub module if there are include files:
		local _DEVEL_SUBMODULE_FILE=$MAGISK_MODULE_TMPDIR/${MAGISK_MODULE_NAME}-dev.submodule.sh
		echo MAGISK_SUBMODULE_INCLUDE=\"include share/vala share/man/man3 lib/pkgconfig share/aclocal lib/cmake $MAGISK_MODULE_INCLUDE_IN_DEVMODULE\" > "$_DEVEL_SUBMODULE_FILE"
		echo "MAGISK_SUBMODULE_DESCRIPTION=\"Development files for ${MAGISK_MODULE_NAME}\"" >> "$_DEVEL_SUBMODULE_FILE"
		if [ -n "$MAGISK_MODULE_DEVMODULE_DEPENDS" ]; then
			echo "MAGISK_SUBMODULE_DEPENDS=\"$MAGISK_MODULE_DEVMODULE_DEPENDS\"" >> "$_DEVEL_SUBMODULE_FILE"
		fi
		if [ -n "$MAGISK_MODULE_DEVMODULE_BREAKS" ]; then
			echo "MAGISK_SUBMODULE_BREAKS=\"$MAGISK_MODULE_DEVMODULE_BREAKS\"" >> "$_DEVEL_SUBMODULE_FILE"
		fi
		if [ -n "$MAGISK_MODULE_DEVMODULE_REPLACES" ]; then
			echo "MAGISK_SUBMODULE_REPLACES=\"$MAGISK_MODULE_DEVMODULE_REPLACES\"" >> "$_DEVEL_SUBMODULE_FILE"
		fi
	fi

	# Now build all sub modules
	rm -Rf "$MAGISK_TOPDIR/$MAGISK_MODULE_NAME/submodules"
	for submodule in $MAGISK_MODULE_BUILDER_DIR/*.submodule.sh $MAGISK_MODULE_TMPDIR/*submodule.sh; do
		test ! -f "$submodule" && continue
		local SUB_MODULE_NAME
		SUB_MODULE_NAME=$(basename "$submodule" .submodule.sh)
		magisk_log "creating submodule $SUB_MODULE_NAME.."
		# Default value is same as main module, but sub module may override:
		local MAGISK_SUBMODULE_PLATFORM_INDEPENDENT=$MAGISK_MODULE_PLATFORM_INDEPENDENT
		local SUB_MODULE_DIR=$MAGISK_TOPDIR/$MAGISK_MODULE_NAME/submodules/$SUB_MODULE_NAME
		local MAGISK_SUBMODULE_BREAKS=""
		local MAGISK_SUBMODULE_DEPENDS=""
		local MAGISK_SUBMODULE_CONFLICTS=""
		local MAGISK_SUBMODULE_REPLACES=""
		local MAGISK_SUBMODULE_CONFFILES=""
		local MAGISK_SUBMODULE_DEPEND_ON_PARENT=""
		local SUB_MODULE_MASSAGE_DIR=$SUB_MODULE_DIR/massage/$MAGISK_PREFIX
		local SUB_MODULE_MODULE_DIR=$SUB_MODULE_DIR/module
		mkdir -p "$SUB_MODULE_MASSAGE_DIR" "$SUB_MODULE_MODULE_DIR"

		# shellcheck source=/dev/null
		source "$submodule"

		for includeset in $MAGISK_SUBMODULE_INCLUDE; do
			local _INCLUDE_DIRSET
			_INCLUDE_DIRSET=$(dirname "$includeset")
			test "$_INCLUDE_DIRSET" = "." && _INCLUDE_DIRSET=""
			if [ -e "$includeset" ] || [ -L "$includeset" ]; then
				# Add the -L clause to handle relative symbolic links:
				mkdir -p "$SUB_MODULE_MASSAGE_DIR/$_INCLUDE_DIRSET"
				mv "$includeset" "$SUB_MODULE_MASSAGE_DIR/$_INCLUDE_DIRSET"
			fi
		done

		local SUB_MODULE_ARCH=$MAGISK_ARCH
		test -n "$MAGISK_SUBMODULE_PLATFORM_INDEPENDENT" && SUB_MODULE_ARCH=all

		cd $SUB_MODULE_DIR/massage
		local SUB_MODULE_INSTALLSIZE
		SUB_MODULE_INSTALLSIZE=$(du -sk . | cut -f 1)
		tar -chJf $SUB_MODULE_MODULE_DIR/data.tar.xz -C $(pwd)/ .

		#mkdir -p DEBIAN
		#cd DEBIAN

		#cat > control <<-HERE
		#	Package: $SUB_MODULE_NAME
		#	Architecture: ${SUB_MODULE_ARCH}
		#	Installed-Size: ${SUB_MODULE_INSTALLSIZE}
		#	Maintainer: $MAGISK_MODULE_MAINTAINER
		#	Version: $MAGISK_MODULE_FULLVERSION
		#	Homepage: $MAGISK_MODULE_HOMEPAGE
		#HERE

		local PKG_DEPS_SPC=" ${MAGISK_MODULE_DEPENDS//,/} "

		if [ -z "$MAGISK_SUBMODULE_DEPEND_ON_PARENT" ] && [ "${PKG_DEPS_SPC/ $SUB_MODULE_NAME /}" = "$PKG_DEPS_SPC" ]; then
		    MAGISK_SUBMODULE_DEPENDS+=", $MAGISK_MODULE_NAME (= $MAGISK_MODULE_FULLVERSION)"
		elif [ "$MAGISK_SUBMODULE_DEPEND_ON_PARENT" = unversioned ]; then
		    MAGISK_SUBMODULE_DEPENDS+=", $MAGISK_MODULE_NAME"
		elif [ "$MAGISK_SUBMODULE_DEPEND_ON_PARENT" = deps ]; then
		    MAGISK_SUBMODULE_DEPENDS+=", $MAGISK_MODULE_DEPENDS"
		fi

		#test ! -z "$MAGISK_SUBMODULE_DEPENDS" && echo "Depends: ${MAGISK_SUBMODULE_DEPENDS/#, /}" >> control
		#test ! -z "$MAGISK_SUBMODULE_BREAKS" && echo "Breaks: $MAGISK_SUBMODULE_BREAKS" >> control
		#test ! -z "$MAGISK_SUBMODULE_CONFLICTS" && echo "Conflicts: $MAGISK_SUBMODULE_CONFLICTS" >> control
		#test ! -z "$MAGISK_SUBMODULE_REPLACES" && echo "Replaces: $MAGISK_SUBMODULE_REPLACES" >> control
		#echo "Description: $MAGISK_SUBMODULE_DESCRIPTION" >> control

		for f in $MAGISK_SUBMODULE_CONFFILES; do echo "$MAGISK_PREFIX/$f" >> conffiles; done

		# Create the actual .zip file:
		MAGISK_SUBMODULE_ZIPFILE=$MAGISK_ZIPDIR/${SUB_MODULE_NAME}${DEBUG}_${MAGISK_MODULE_FULLVERSION}_${SUB_MODULE_ARCH}.zip
		cd "$SUB_MODULE_DIR/massage"
		zip --symlinks -r "$MAGISK_SUBMODULE_ZIPFILE" .

		# Go back to main module:
		cd "$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX"
		magisk_log "submodule $SUB_MODULE_NAME created"
	done
}
