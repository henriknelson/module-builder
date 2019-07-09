magisk_running_in_docker() {
    if [ -f /.dockerenv ]; then
        echo 1
    else
        echo 0
    fi
}
