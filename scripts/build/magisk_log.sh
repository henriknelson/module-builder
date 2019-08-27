magisk_log() {
	TEXT="$*"
	#[[ -v MAGISK_MODULE_NAME ]] && TAG="[module-builder-$MAGISK_MODULE_NAME]" || TAG="[module-builder]"
	TAG="[module-builder]"
	echo -e "\033[1m\033[38;5;4m$TAG\033[m\033[38;5;15m - \033[m\033[1m$TEXT\033[1m"
}


magisk_log_divider() {
	magisk_log "--------------------------"
}


magisk_log_header() {
	echo -e "\n"
	magisk_log_divider
	magisk_log "$*"
	magisk_log_divider
	echo -e "\n"
}
