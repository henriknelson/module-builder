#!/usr/bin/env bash

. scripts/properties.sh

check_module() { # path
	local path=$1
	local module=$(basename $path)
	MAGISK_MODULE_REVISION=0
	MAGISK_ARCH=aarch64
	. $path/build.sh
	if [ "$MAGISK_MODULE_REVISION" != "0" ] || [ "$MAGISK_MODULE_VERSION" != "${MAGISK_MODULE_VERSION/-/}" ]; then
		MAGISK_MODULE_VERSION+="-$MAGISK_MODULE_REVISION"
	fi
	echo "$module=$MAGISK_MODULE_VERSION"
}

for path in modules/*; do
(
	check_module $path
)
done
