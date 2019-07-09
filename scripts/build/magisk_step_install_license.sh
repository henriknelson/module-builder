magisk_step_install_license() {
	mkdir -p "$MAGISK_PREFIX/share/doc/$MAGISK_MODULE_NAME"

	if [ ! "${MAGISK_MODULE_LICENSE_FILE}" = "" ]; then
		local LICENSE
		for LICENSE in $MAGISK_MODULE_LICENSE_FILE; do
			if [ ! -f "$MAGISK_MODULE_SRCDIR/$LICENSE" ]; then
				magisk_error_exit "$MAGISK_MODULE_SRCDIR/$LICENSE does not exist"
			fi
			cp -f "${MAGISK_MODULE_SRCDIR}/${LICENSE}" "${MAGISK_PREFIX}/share/doc/${MAGISK_MODULE_NAME}"/
		done
	else
		local COUNTER=0
		local LICENSE
		while read -r LICENSE; do
			if [ -f "$MAGISK_SCRIPTDIR/modules/magisk-licenses/LICENSES/${LICENSE}.txt" ]; then
				if [[ $COUNTER -gt 0 ]]; then
					ln -sf "../../LICENSES/${LICENSE}.txt" "$MAGISK_PREFIX/share/doc/$MAGISK_MODULE_NAME/LICENSE.${COUNTER}"
				else
					ln -sf "../../LICENSES/${LICENSE}.txt" "$MAGISK_PREFIX/share/doc/$MAGISK_MODULE_NAME/LICENSE"
				fi
			fi
			COUNTER=$((COUNTER + 1))
		done < <(echo "$MAGISK_MODULE_LICENSE" | sed "s/,/\n/g")

		for LICENSE in "$MAGISK_PREFIX/share/doc/$MAGISK_MODULE_NAME"/LICENSE*; do
			if [ "$LICENSE" = "$MAGISK_PREFIX/share/doc/$MAGISK_MODULE_NAME/LICENSE*" ]; then
				echo "No LICENSE file.:"
				#magisk_error_exit "No LICENSE file was installed for $MAGISK_MODULE_NAME"
			fi
		done
	fi
}
