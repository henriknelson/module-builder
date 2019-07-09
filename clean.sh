#!/bin/bash
# clean.sh - clean everything.
set -e -u

# Utility function to see if we are running inside a docker container or not
source scripts/build/magisk_docker_check.sh

if [ ! "$(magisk_running_in_docker)" -eq 1 ]; then
        ./scripts/run-docker.sh $0 "$@"
	exit 0
fi

# Read settings from .magiskrc if existing
test -f $HOME/.magiskrc && . $HOME/.magiskrc
: ${MAGISK_TOPDIR:="$HOME/.magisk-build"}

echo "nelshh/module-builder - cleaning.."
sudo rm -Rf /data/* $MAGISK_TOPDIR
