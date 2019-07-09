#!/usr/bin/env bash
##
##  Package uploader for Bintray.
##
##  Leonid Plyushch <leonid.plyushch@gmail.com> (C) 2019
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

set -o errexit
set -o nounset

MAGISK_MODULES_BASEDIR=$(realpath "$(dirname "$0")/../")

# Verify that script is correctly installed to Termux repository.
if [ ! -d "$MAGISK_MODULES_BASEDIR/modules" ]; then
	echo "[!] Cannot find directory 'modules'."
	exit 1
fi

# Check dependencies.
if [ -z "$(command -v curl)" ]; then
	echo "[!] Package 'curl' is not installed."
	exit 1
fi
if [ -z "$(command -v find)" ]; then
	echo "[!] Package 'findutils' is not installed."
	exit 1
fi
if [ -z "$(command -v grep)" ]; then
	echo "[!] Package 'grep' is not installed."
	exit 1
fi
if [ -z "$(command -v jq)" ]; then
	echo "[!] Package 'jq' is not installed."
	exit 1
fi

###################################################################

# In this variable a module metadata will be stored.
declare -gA MODULE_METADATA

# Initialize default configuration.
ZIPFILES_DIR_PATH="$MAGISK_MODULES_BASEDIR/zips"
METADATA_GEN_MODE=false
MODULE_CLEANUP_MODE=false
MODULE_DELETION_MODE=false
SCRIPT_EMERG_EXIT=false

# Special variable to force script to exit with error status
# when everything finished. Should be set only when non-script
# errors occur, e.g. curl request failure.
#
# Useful in case if there was an error when uploading modules
# via CI/CD so modules are still uploaded where possible but
# maintainers will be notified about error because pipeline
# will be marked as "failed".
SCRIPT_ERROR_EXIT=false

# Bintray-specific configuration.
BINTRAY_REPO_NAME="termux-modules-24"
BINTRAY_REPO_GITHUB="termux/termux-packages"
BINTRAY_REPO_DISTRIBUTION="stable"
BINTRAY_REPO_COMPONENT="main"

# Bintray credentials that should be set as external environment
# variables by user.
: "${BINTRAY_USERNAME:=""}"
: "${BINTRAY_API_KEY:=""}"
: "${BINTRAY_GPG_SUBJECT:=""}"
: "${BINTRAY_GPG_PASSPHRASE:=""}"

# If BINTRAY_GPG_SUBJECT is not specified, then signing will be
# done with gpg key of subject '$BINTRAY_USERNAME'.
if [ -z "$BINTRAY_GPG_SUBJECT" ]; then
	BINTRAY_GPG_SUBJECT="$BINTRAY_USERNAME"
fi

# Packages are built and uploaded for Termux organisation.
BINTRAY_SUBJECT="termux"

###################################################################

## Print message to stderr.
## Takes same arguments as command 'echo'.
msg() {
	echo "$@" >&2
}


## Blocks terminal to prevent any user input.
## Takes no arguments.
block_terminal() {
	stty -echo -icanon time 0 min 0 2>/dev/null || true
	stty quit undef susp undef 2>/dev/null || true
}


## Unblocks terminal blocked with block_terminal() function.
## Takes no arguments.
unblock_terminal() {
	while read -r; do
		true;
	done
	stty sane 2>/dev/null || true
}


## Process request for aborting script execution.
## Used by signal trap.
## Takes no arguments.
request_emerg_exit() {
	SCRIPT_EMERG_EXIT=true
}


## Handle emergency exit requested by ctrl-c.
## Takes no arguments.
emergency_exit() {
	msg
	recalculate_metadata
	msg "[!] Aborted by user."
	unblock_terminal
	exit 1
}


## Dump everything from $MODULE_METADATA to json structure.
## Takes no arguments.
json_metadata_dump() {
	local old_ifs=$IFS
	local license
	local pkg_licenses=""

	IFS=","
	for license in ${MODULE_METADATA['LICENSES']}; do
		pkg_licenses+="\"$(echo "$license" | sed -r 's/^\s*(\S+(\s+\S+)*)\s*$/\1/')\","
	done
	pkg_licenses=${pkg_licenses%%,}
	IFS=$old_ifs

	cat <<- EOF
	{
	    "name": "${MODULE_METADATA['NAME']}",
	    "desc": "${MODULE_METADATA['DESCRIPTION']}",
	    "version": "${MODULE_METADATA['VERSION_FULL']}",
	    "licenses": [${pkg_licenses}],
	    "vcs_url": "https://github.com/${BINTRAY_REPO_GITHUB}",
	    "website_url": "${MODULE_METADATA['WEBSITE_URL']}",
	    "issue_tracker_url": "https://github.com/${BINTRAY_REPO_GITHUB}/issues",
	    "github_repo": "${BINTRAY_REPO_GITHUB}",
	    "public_download_numbers": "true",
	    "public_stats": "false"
	}
	EOF
}


## Request metadata recalculation and signing.
## Takes no arguments.
recalculate_metadata() {
	local curl_response
	local http_status_code
	local api_response_message

	msg -n "[@] Requesting metadata recalculation... "
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request POST \
			--header "Content-Type: application/json" \
			--data "{\"subject\":\"${BINTRAY_GPG_SUBJECT}\",\"passphrase\":\"$BINTRAY_GPG_PASSPHRASE\"}" \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/calc_metadata/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/"
	)

	http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
	api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

	if [ "$http_status_code" = "202" ]; then
		msg "done"
	else
		msg "failure"
		msg "[!] $api_response_message"
		SCRIPT_ERROR_EXIT=true
	fi
}


## Request deletion of the specified module.
## Takes only one argument - module name.
delete_module() {
	msg -n "   * ${1}: "

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	local curl_response
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request DELETE \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/modules/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${1}"
	)

	local http_status_code
	http_status_code=$(
		echo "$curl_response" | cut -d'|' -f2
	)

	local api_response_message
	api_response_message=$(
		echo "$curl_response" | cut -d'|' -f1 | jq -r .message
	)

	if [ "$http_status_code" = "200" ] || [ "$http_status_code" = "404" ]; then
		msg "success"
	else
		msg "$api_response_message"
		SCRIPT_ERROR_EXIT=true
	fi

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi
}


## Leave only the latest version of specified module and remove old ones.
## Takes only one argument - module name.
delete_old_versions_from_module() {
	local module_versions
	local module_latest_version
	local curl_response
	local http_status_code
	local api_response_message

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	msg -n "    * ${1}: checking latest version... "
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request GET \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/modules/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${1}"
	)

	http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
	api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

	if [ "$http_status_code" = "200" ]; then
		module_latest_version=$(
			echo "$curl_response" | cut -d'|' -f1 | jq -r .latest_version | \
				sed 's/\./\\./g'
		)

		module_versions=$(
			echo "$curl_response" | cut -d'|' -f1 | jq -r '.versions[]' | \
				grep -v "^$module_latest_version$" || true
		)
	else
		msg "$api_response_message."
		SCRIPT_ERROR_EXIT=true
		return 1
	fi

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	if [ -n "$module_versions" ]; then
		local old_version
		for old_version in $module_versions; do
			if $SCRIPT_EMERG_EXIT; then
				emergency_exit
			fi

			msg -ne "\\r\\e[2K    * ${1}: deleting '$old_version'... "
			curl_response=$(
				curl \
					--silent \
					--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
					--request DELETE \
					--write-out "|%{http_code}" \
					"https://api.bintray.com/modules/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${1}/versions/${old_version}"
			)

			http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
			api_response_message=$(
				echo "$curl_response" | cut -d'|' -f1 | jq -r .message
			)

			if [ "$http_status_code" != "200" ] && [ "$http_status_code" != "404" ]; then
				msg "$api_response_message"
				SCRIPT_ERROR_EXIT=true
				return 1
			fi

			if $SCRIPT_EMERG_EXIT; then
				emergency_exit
			fi
		done
	fi

	msg -e "\\r\\e[2K    * ${1}: success"
}


## Upload the specified module. Will also create a new version entry
## if required. When upload is done within the same version, already existing
## *.zip files will not be replaced.
##
## Note that upload_module() detects right *.zip files by using naming scheme
## defined in the build script. It does not care about actual content stored in
## the module so the good advice is to never rename *.zip files once they built.
##
## Function takes only one argument - module name.
upload_module() {
	local curl_response
	local http_status_code
	local api_response_message

	declare -A zipfiles_catalog

	local arch
	for arch in all aarch64 arm i686 x86_64; do
		# Regular module.
		if [ -f "$ZIPFILES_DIR_PATH/${1}_${MODULE_METADATA['VERSION_FULL']}_${arch}.zip" ]; then
			zipfiles_catalog["${1}_${MODULE_METADATA['VERSION_FULL']}_${arch}.zip"]=${arch}
		fi

		# Development module.
		if [ -f "$ZIPFILES_DIR_PATH/${1}-dev_${MODULE_METADATA['VERSION_FULL']}_${arch}.zip" ]; then
			zipfiles_catalog["${1}-dev_${MODULE_METADATA['VERSION_FULL']}_${arch}.zip"]=${arch}
		fi

		# Discover submodules.
		local file
		for file in $(find "$MAGISK_MODULES_BASEDIR/modules/${1}/" -maxdepth 1 -type f -iname \*.submodule.sh | sort); do
			file=$(basename "$file")

			if [ -f "$ZIPFILES_DIR_PATH/${file%%.submodule.sh}_${MODULE_METADATA['VERSION_FULL']}_${arch}.zip" ]; then
				zipfiles_catalog["${file%%.submodule.sh}_${MODULE_METADATA['VERSION_FULL']}_${arch}.zip"]=${arch}
			fi
		done
	done

	# Verify that our catalog is not empty.
	set +o nounset
	if [ ${#zipfiles_catalog[@]} -eq 0 ]; then
		set -o nounset
		msg "    * ${1}: skipping because no files to upload."
		SCRIPT_ERROR_EXIT=true
		return 1
	fi
	set -o nounset

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	# Create new entry for module.
	msg -n "    * ${1}: creating entry for version '${MODULE_METADATA['VERSION_FULL']}'... "
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request POST \
			--header "Content-Type: application/json" \
			--data "$(json_metadata_dump)" \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/modules/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}"
	)

	http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
	api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

	if [ "$http_status_code" != "201" ] && [ "$http_status_code" != "409" ]; then
		msg "$api_response_message"
		SCRIPT_ERROR_EXIT=true
		return 1
	fi

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	for item in "${!zipfiles_catalog[@]}"; do
		local module_arch=${zipfiles_catalog[$item]}

		if $SCRIPT_EMERG_EXIT; then
			emergency_exit
		fi

		msg -ne "\\r\\e[2K    * ${1}: uploading '$item'... "
		curl_response=$(
			curl \
				--silent \
				--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
				--request PUT \
				--header "X-Bintray-Debian-Distribution: $BINTRAY_REPO_DISTRIBUTION" \
				--header "X-Bintray-Debian-Component: $BINTRAY_REPO_COMPONENT" \
				--header "X-Bintray-Debian-Architecture: $module_arch" \
				--header "X-Bintray-Package: ${1}" \
				--header "X-Bintray-Version: ${MODULE_METADATA['VERSION_FULL']}" \
				--upload-file "$ZIPFILES_DIR_PATH/$item" \
				--write-out "|%{http_code}" \
				"https://api.bintray.com/content/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${module_arch}/${item}"
		)

		http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
		api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

		if [ "$http_status_code" != "201" ] && [ "$http_status_code" != "409" ]; then
			msg "$api_response_message"
			SCRIPT_ERROR_EXIT=true
			return 1
		fi

		if $SCRIPT_EMERG_EXIT; then
			emergency_exit
		fi
	done

	# Publishing module only after uploading all it's files. This will prevent
	# spawning multiple metadata-generation jobs and will allow to sign metadata
	# with maintainer's key.
	msg -ne "\\r\\e[2K    * ${1}: publishing... "
	curl_response=$(
		curl \
			--silent \
			--user "${BINTRAY_USERNAME}:${BINTRAY_API_KEY}" \
			--request POST \
			--header "Content-Type: application/json" \
			--data "{\"subject\":\"${BINTRAY_GPG_SUBJECT}\",\"passphrase\":\"$BINTRAY_GPG_PASSPHRASE\"}" \
			--write-out "|%{http_code}" \
			"https://api.bintray.com/content/${BINTRAY_SUBJECT}/${BINTRAY_REPO_NAME}/${1}/${MODULE_METADATA['VERSION_FULL']}/publish"
	)

	http_status_code=$(echo "$curl_response" | cut -d'|' -f2)
	api_response_message=$(echo "$curl_response" | cut -d'|' -f1 | jq -r .message)

	if [ "$http_status_code" = "200" ]; then
		msg -e "\\r\\e[2K    * ${1}: success"
	else
		msg "$api_response_message"
		SCRIPT_ERROR_EXIT=true
		return 1
	fi
}


## Extact value of specified variable from build.sh script.
## Takes 2 arguments: module name, variable name.
get_module_property() {
	local buildsh_path="$MAGISK_MODULES_BASEDIR/modules/$1/build.sh"
	local extracted_value

	extracted_value=$(
		set +o nounset
		set -o noglob

		# When sourcing external code, do not expose variables
		# with sensitive information.
		unset BINTRAY_API_KEY
		unset BINTRAY_GPG_PASSPHRASE
		unset BINTRAY_GPG_SUBJECT
		unset BINTRAY_SUBJECT
		unset BINTRAY_USERNAME

		if [ -e "$MAGISK_MODULES_BASEDIR/scripts/properties.sh" ]; then
			. "$MAGISK_MODULES_BASEDIR/scripts/properties.sh" 2>/dev/null
		fi

		. "$buildsh_path" 2>/dev/null

		echo "${!2}"

		set +o noglob
		set -o nounset
	)

	echo "$extracted_value"
}


## Execute desired action on specified modules.
## Takes arbitrary amount of arguments - module names.
process_modules() {
	local module_name
	local module_name_list
	local buildsh_path

	if $MODULE_CLEANUP_MODE; then
		msg "[@] Removing old versions:"
	elif $MODULE_DELETION_MODE; then
		msg "[@] Deleting modules from remote:"
	elif $METADATA_GEN_MODE; then
		recalculate_metadata
		msg "[@] Finished."
		return 0
	else
		msg "[@] Uploading modules:"
	fi
	msg

	block_terminal

	# Remove duplicates from the list of the module names.
	readarray -t module_name_list < <(printf '%s\n' "${@}" | sort -u)

	for module_name in "${module_name_list[@]}"; do
		if $SCRIPT_EMERG_EXIT; then
			emergency_exit
		fi

		if $MODULE_DELETION_MODE; then
			delete_module "$module_name" || continue
		else
			if [ ! -f "$MAGISK_MODULES_BASEDIR/modules/$module_name/build.sh" ]; then
				msg "    * ${module_name}: skipping because such module does not exist."
				SCRIPT_ERROR_EXIT=true
				continue
			fi

			MODULE_METADATA["NAME"]="$module_name"

			MODULE_METADATA["LICENSES"]=$(get_module_property "$module_name" "MAGISK_MODULE_LICENSE")
			if [ -z "${MODULE_METADATA['LICENSES']}" ]; then
				msg "    * ${module_name}: skipping because field 'MAGISK_MODULE_LICENSE' is empty."
				SCRIPT_ERROR_EXIT=true
				continue
			elif grep -qP '.*(custom|non-free).*' <(echo "${MODULE_METADATA['LICENSES']}"); then
				MODULE_METADATA["LICENSES"]=""
			fi

			MODULE_METADATA["DESCRIPTION"]=$(get_module_property "$module_name" "MAGISK_MODULE_DESCRIPTION")
			if [ -z "${MODULE_METADATA['DESCRIPTION']}" ]; then
				msg "    * ${module_name}: skipping because field 'MAGISK_MODULE_DESCRIPTION' is empty."
				SCRIPT_ERROR_EXIT=true
				continue
			fi

			MODULE_METADATA["WEBSITE_URL"]=$(get_module_property "$module_name" "MAGISK_MODULE_HOMEPAGE")
			if [ -z "${MODULE_METADATA['WEBSITE_URL']}" ]; then
				msg "    * ${module_name}: skipping because field 'MAGISK_MODULE_HOMEPAGE' is empty."
				SCRIPT_ERROR_EXIT=true
				continue
			fi

			MODULE_METADATA["VERSION"]=$(get_module_property "$module_name" "MAGISK_MODULE_VERSION")
			if [ -z "${MODULE_METADATA['VERSION']}" ]; then
				msg "    * ${module_name}: skipping because field 'MAGISK_MODULE_VERSION' is empty."
				SCRIPT_ERROR_EXIT=true
				continue
			fi

			MODULE_METADATA["REVISION"]=$(get_module_property "$module_name" "MAGISK_MODULE_REVISION")
			if [ -n "${MODULE_METADATA['REVISION']}" ]; then
				MODULE_METADATA["VERSION_FULL"]="${MODULE_METADATA['VERSION']}-${MODULE_METADATA['REVISION']}"
			else
				if [ "${MODULE_METADATA['VERSION']}" != "${MODULE_METADATA['VERSION']/-/}" ]; then
					MODULE_METADATA["VERSION_FULL"]="${MODULE_METADATA['VERSION']}-0"
				else
					MODULE_METADATA["VERSION_FULL"]="${MODULE_METADATA['VERSION']}"
				fi
			fi

			if $MODULE_CLEANUP_MODE; then
				delete_old_versions_from_module "$module_name" || continue
			else
				upload_module "$module_name" || continue
			fi
		fi
	done

	if $SCRIPT_EMERG_EXIT; then
		emergency_exit
	fi

	unblock_terminal

	msg
	if $MODULE_CLEANUP_MODE || $MODULE_DELETION_MODE; then
		recalculate_metadata
	fi
	msg "[@] Finished."
}


## Just print information about usage.
## Takes no arumnets.
show_usage() {
	msg
	msg "Usage: module_uploader.sh [OPTIONS] [module name] ..."
	msg
	msg "A command line client for Bintray designed for managing"
	msg "Termux *.zip modules."
	msg
	msg "=========================================================="
	msg
	msg "Primarily indended to be used by CI systems for automatic"
	msg "module uploads but it can be used for manual uploads too."
	msg
	msg "Before using this script, check that you have all"
	msg "necessary credentials for accessing repository."
	msg
	msg "Credentials are specified via environment variables:"
	msg
	msg "  BINTRAY_USERNAME        - User name."
	msg "  BINTRAY_API_KEY         - User's API key."
	msg "  BINTRAY_GPG_SUBJECT     - Owner of GPG key."
	msg "  BINTRAY_GPG_PASSPHRASE  - GPG key passphrase."
	msg
	msg "=========================================================="
	msg
	msg "Options:"
	msg
	msg "  -h, --help         Print this help."
	msg
	msg "  -c, --cleanup      Action. Clean selected modules by"
	msg "                     removing older versions from the remote."
	ymsg
	msg "  -d, --delete       Action. Remove selected modules from"
	msg "                     remote."
	msg
	msg "  -r, --regenerate   Action. Request metadata recalculation"
	msg "                     and signing on the remote."
	msg
	msg
	msg "  -p, --path [path]  Specify a directory containing *.zip"
	msg "                     files ready for uploading."
	msg "                     Default is './zips'."
	msg
	msg "=========================================================="
}

###################################################################

trap request_emerg_exit INT

while getopts ":-:hcdrp:" opt; do
	case "$opt" in
		-)
			case "$OPTARG" in
				help)
					show_usage
					exit 0
					;;
				cleanup)
					MODULE_CLEANUP_MODE=true
					;;
				delete)
					MODULE_DELETION_MODE=true
					;;
				regenerate)
					METADATA_GEN_MODE=true;
					;;
				path)
					ZIPFILES_DIR_PATH="${!OPTIND}"
					OPTIND=$((OPTIND + 1))

					if [ -z "$ZIPFILES_DIR_PATH" ]; then
						msg "[!] Option '--${OPTARG}' requires argument."
						show_usage
						exit 1
					fi

					if [ ! -d "$ZIPFILES_DIR_PATH" ]; then
						msg "[!] Directory '$ZIPFILES_DIR_PATH' does not exist."
						show_usage
						exit 1
					fi
					;;
				*)
					msg "[!] Invalid option '$OPTARG'."
					show_usage
					exit 1
					;;
			esac
			;;
		h)
			show_usage
			exit 0
			;;
		c)
			MODULE_CLEANUP_MODE=true
			;;
		d)
			MODULE_DELETION_MODE=true
			;;
		r)
			METADATA_GEN_MODE=true
			;;
		p)
			ZIPFILES_DIR_PATH="${OPTARG}"
			if [ ! -d "$ZIPFILES_DIR_PATH" ]; then
				msg "[!] Directory '$ZIPFILES_DIR_PATH' does not exist."
				show_usage
				exit 1
			fi
			;;
		*)
			msg "[!] Invalid option '-${OPTARG}'."
			show_usage
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

if [ $# -lt 1 ] && ! $METADATA_GEN_MODE; then
	msg "[!] No modules specified."
	show_usage
	exit 1
fi

# These variables should never be changed.
readonly ZIPFILES_DIR_PATH
readonly MODULE_DELETION_MODE
readonly MODULE_CLEANUP_MODE
readonly MAGISK_MODULES_BASEDIR

# Check if no mutually exclusive options used.
if $MODULE_CLEANUP_MODE && $METADATA_GEN_MODE; then
	msg "[!] Options '-c|--cleanup' and '-r|--regenerate' are mutually exclusive."
	exit 1
fi
if $MODULE_CLEANUP_MODE && $MODULE_DELETION_MODE; then
	msg "[!] Options '-c|--cleanup' and '-d|--delete' are mutually exclusive."
	exit 1
fi
if $MODULE_DELETION_MODE && $METADATA_GEN_MODE; then
	msg "[!] Options '-d|--delete' and '-r|--regenerate' are mutually exclusive."
	exit 1
fi

# Without Bintray credentials this script is useless.
if [ -z "$BINTRAY_USERNAME" ]; then
	msg "[!] Variable 'BINTRAY_USERNAME' is not set."
	exit 1
fi
if [ -z "$BINTRAY_API_KEY" ]; then
	msg "[!] Variable 'BINTRAY_API_KEY' is not set."
	exit 1
fi
if [ -z "$BINTRAY_GPG_SUBJECT" ]; then
	msg "[!] Variable 'BINTRAY_GPG_SUBJECT' is not set."
	exit 1
fi

process_modules "$@"

if $SCRIPT_ERROR_EXIT; then
	exit 1
else
	exit 0
fi
