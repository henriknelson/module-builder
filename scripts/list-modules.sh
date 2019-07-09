#!/bin/bash
# list-modules.sh - tool to list all module with home pages and descriptions

show_module() {
	. $1/build.sh
	local module=$(basename $1)
	echo "$module($MAGISK_MODULE_VERSION): $MAGISK_MODULE_HOMEPAGE"
	echo "       $MAGISK_MODULE_DESCRIPTION"
}

for path in modules/*; do
	( show_module $path )
done
