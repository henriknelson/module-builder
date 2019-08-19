#!/bin/bash
# shellcheck disable=SC1117

set -e -o pipefail -u

# Utility function to see if we are running inside a docker container or not
source scripts/build/magisk_docker_check.sh

if [ ! "$(magisk_running_in_docker)" -eq 1 ]; then
	./scripts/run-docker.sh $0 "$@"
	exit 0
fi

# Utility function to log an error message and exit with an error code.
source scripts/build/magisk_error_exit.sh

# Utility function to log a message.
source scripts/build/magisk_log.sh

if [ "$(uname -o)" = Android ]; then
	magisk_error_exit "On-device builds are not supported - see README.md"
fi


# Lock file to prevent parallel running in the same environment.
MAGISK_BUILD_LOCK_FILE="/tmp/.magisk-build.lck"
if [ ! -e "$MAGISK_BUILD_LOCK_FILE" ]; then
	touch "$MAGISK_BUILD_LOCK_FILE"
fi

# Special variable for internal use. It forces script to ignore
# lock file.
: "${MAGISK_BUILD_IGNORE_LOCK:=false}"

# Utility function to download a resource with an expected checksum.
source scripts/build/magisk_download.sh

# Utility function for golang-using modules to setup a go toolchain.
source scripts/build/setup/magisk_setup_golang.sh

# Utility function for rust-using modules to setup a rust toolchain.
source scripts/build/setup/magisk_setup_rust.sh

# Utility function to setup a current ninja build system.
source scripts/build/setup/magisk_setup_ninja.sh

# Utility function to setup a current meson build system.
source scripts/build/setup/magisk_setup_meson.sh

# Utility function to setup a current cmake build system
source scripts/build/setup/magisk_setup_cmake.sh

# Utility function to setup protobuf:
source scripts/build/setup/magisk_setup_protobuf.sh

# First step is to handle command-line arguments. Not to be overridden by modules.
source scripts/build/magisk_step_handle_arguments.sh

# Setup variables used by the build. Not to be overridden by modules.
source scripts/build/magisk_step_setup_variables.sh

# Save away and restore build setups which may change between builds.
source scripts/build/magisk_step_handle_buildarch.sh

# Function to get MAGISK_MODULE_VERSION from build.sh
source scripts/build/magisk_extract_dep_info.sh

# Function that downloads a .zip (using the magisk_download function)
source scripts/build/magisk_download_zip.sh

# Script to download InRelease, verify it's signature and then download Packages.xz by hash
source scripts/build/magisk_get_repo_files.sh

# Source the module build script and start building. No to be overridden by modules.
source scripts/build/magisk_step_start_build.sh

# Run just after sourcing $MAGISK_MODULE_BUILDER_SCRIPT. May be overridden by modules.
source scripts/build/magisk_step_extract_module.sh

# Hook for modules to act just after the module has been extracted.
# Invoked in $MAGISK_MODULE_SRCDIR.
magisk_step_post_extract_module() {
	return
}

# Optional host build. Not to be overridden by modules.
source scripts/build/magisk_step_handle_hostbuild.sh

# Perform a host build. Will be called in $MAGISK_MODULE_HOSTBUILD_DIR.
# After magisk_step_post_extract_module() and before magisk_step_patch_module()
source scripts/build/magisk_step_host_build.sh

# Setup a standalone Android NDK toolchain. Not to be overridden by modules.
source scripts/build/magisk_step_setup_toolchain.sh

# Apply all *.patch files for the module. Not to be overridden by modules.
source scripts/build/magisk_step_patch_module.sh

# Replace autotools build-aux/config.{sub,guess} with ours to add android targets.
source scripts/build/magisk_step_replace_guess_scripts.sh

# For module scripts to override. Called in $MAGISK_MODULE_BUILDDIR.
magisk_step_pre_configure() {
	return
}

# Setup configure args and run $MAGISK_MODULE_SRCDIR/configure. This function is called from magisk_step_configure
source scripts/build/configure/magisk_step_configure_autotools.sh

# Setup configure args and run cmake. This function is called from magisk_step_configure
source scripts/build/configure/magisk_step_configure_cmake.sh

# Setup configure args and run meson. This function is called from magisk_step_configure
source scripts/build/configure/magisk_step_configure_meson.sh

# Configure the module
source scripts/build/configure/magisk_step_configure.sh

# Hook for modules after configure step
magisk_step_post_configure() {
	return
}

#Always runs after configure step
source scripts/build/magisk_step_before_post_configure.sh

# Make module, either with ninja or make
source scripts/build/magisk_step_make.sh

# Make install, either with ninja, make of cargo
source scripts/build/magisk_step_make_install.sh

# Hook function for module scripts to override.
magisk_step_post_make_install() {
	return
}

# Link/copy the LICENSE for the module to $MAGISK_PREFIX/share/$MAGISK_MODULE_NAME/
source scripts/build/magisk_step_install_license.sh

# Function to cp (through tar) installed files to massage dir
source scripts/build/magisk_step_extract_into_massagedir.sh

# Create all submodules. Run from magisk_step_massage
source scripts/build/magisk_create_submodules.sh

# Function to run various cleanup/fixes
source scripts/build/magisk_step_massage.sh

# Hook for modules after massage step
magisk_step_post_massage() {
	return
}

magisk_step_setup_zipfile() {
	cd "$MAGISK_MODULE_MASSAGEDIR"
	mkdir -p common
	cd common
	echo "#!$MAGISK_PREFIX/bin/sh" >> service.sh
	echo "MODDIR=\${0%/*};" >> service.sh
	cd "$MAGISK_MODULE_MASSAGEDIR" 
}

# Hook function to create {pre,post}install, {pre,post}rm-scripts and similar
magisk_step_create_zipscripts() {
	return
}

# Create the build zip file. Not to be overridden by module scripts.
source scripts/build/magisk_step_create_zipfile.sh

# Finish the build. Not to be overridden by module scripts.
source scripts/build/magisk_step_finish_build.sh

{
	if ! $MAGISK_BUILD_IGNORE_LOCK; then
		flock -n 5 || magisk_error_exit "Another build is already running within same environment."
	fi
	#magisk_log "handling arguments $@..\n"
	magisk_step_handle_arguments "$@"
	#magisk_log "setting up variables..\n"
	magisk_step_setup_variables
	#magisk_log "handling buildarch..\n"
	magisk_step_handle_buildarch
	#magisk_log_header "magisk_step_start_build()"
	magisk_step_start_build
	magisk_log_header "magisk_step_extract_module()"
	magisk_step_extract_module
	cd "$MAGISK_MODULE_SRCDIR"
	#magisk_log "module extracted\n"
	magisk_step_post_extract_module
	#magisk_log "handling hostbuild..\n"
	magisk_step_handle_hostbuild
	#magisk_log "setting up toolchain..\n"
	magisk_step_setup_toolchain
	magisk_log_header "magisk_step_patch_module()"
	magisk_step_patch_module
	magisk_step_replace_guess_scripts
	cd "$MAGISK_MODULE_SRCDIR"
	#magisk_log "hook pre-configure\n"
	magisk_step_pre_configure
	cd "$MAGISK_MODULE_BUILDDIR"
	magisk_log_header "magisk_step_configure()"
	magisk_step_configure
	cd "$MAGISK_MODULE_BUILDDIR"
	#magisk_log "hook before post-configure\n"
	magisk_step_before_post_configure
	cd "$MAGISK_MODULE_BUILDDIR"
	#magisk_log "hook post-configure\n"
	magisk_step_post_configure
	cd "$MAGISK_MODULE_BUILDDIR"
	magisk_log_header "magisk_step_make()"
	magisk_step_make
	cd "$MAGISK_MODULE_BUILDDIR"
	magisk_log_header "magisk_step_make_install()"
	magisk_step_make_install
	cd "$MAGISK_MODULE_BUILDDIR"
	magisk_step_post_make_install
	magisk_step_install_license
	cd "$MAGISK_MODULE_MASSAGEDIR"
	magisk_step_extract_into_massagedir
	cd "$MAGISK_MODULE_MASSAGEDIR"
	magisk_step_massage
	cd "$MAGISK_MODULE_MASSAGEDIR/$MAGISK_PREFIX"
	magisk_step_post_massage
	magisk_step_setup_zipfile
	magisk_step_create_zipfile
	magisk_step_finish_build
} 5< "$MAGISK_BUILD_LOCK_FILE"
