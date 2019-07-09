#!/usr/bin/env bash
# check-versions.sh - script to open modules in a browser for checking their versions

OPEN=xdg-open
if [ $(uname) = Darwin ]; then OPEN=open; fi

check_module() { # path
	local path=$1
	local module=$(basename $path)
	. $path/build.sh
	echo -n "$module - $MAGISK_MODULE_VERSION"
	read
	$OPEN $MAGISK_MODULE_HOMEPAGE
}

# Run each module in separate process since we include their environment variables:
for path in modules/*; do
(
	check_module $path
)
done
