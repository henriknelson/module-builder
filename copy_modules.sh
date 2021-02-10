#!/bin/env bash
MODULE_NAME="$1"
DIR_NAME="modules/$MODULE_NAME"

# If module does not exist..
if [ ! -d "${DIR_NAME}" ]; then
	# ..create target folder in modules directory
	mkdir -p "${DIR_NAME}"
else
	# ..else, create new backup folder in module..
	TMP_DIR_NAME="$DIR_NAME/backup"
	n=0
	while [ -d "${TMP_DIR_NAME}_$n" ]; do n=$((n+1)); done
	NEW_TEMP_FOLDER="${TMP_DIR_NAME}_$n"
	mkdir -p "${NEW_TEMP_FOLDER}"
	# ..and move all current module files to the newly created backup folder
	find "$DIR_NAME" -maxdepth 1 -type f -exec mv {} "$NEW_TEMP_FOLDER" \;
fi

# Copy the latest files from the termux package repository to our module folder
cp -r /home/henrik/dev/projects/termux-packages/packages/$MODULE_NAME/* $DIR_NAME

# Rename all subpackages to submodules, and replace all needed to be replaced within files
for file in $(find "$DIR_NAME" -maxdepth 1 -type f); do
	sed -i 's/TERMUX_PKG/MAGISK_MODULE/g' $file;
	sed -i 's/TERMUX_SUBPKG/MAGISK_SUBMODULE/g' $file;
	sed -i 's/TERMUX_/MAGISK_/g' $file;
	sed -i 's/termux_/magisk_/g' $file;
	rename 's/subpackage/submodule/g' $file;
done
