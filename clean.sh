#!/bin/sh
# clean.sh - clean everything.
set -e -u

# Read settings from .magiskrc if existing
test -f $HOME/.magiskrc && . $HOME/.magiskrc
: ${MAGISK_TOPDIR:="$HOME/.magisk-build"}

rm -Rf /data/* $MAGISK_TOPDIR
