#!/bin/sh
set -e -u

CONTAINER=nelshh-module-builder
IMAGE=nelshh/module-builder:latest

docker pull $IMAGE

LATEST=$(docker inspect --format "{{.Id}}" $IMAGE)
RUNNING=$(docker inspect --format "{{.Image}}" $CONTAINER)

if [ $LATEST = $RUNNING ]; then
	echo "Image '$IMAGE' used in the container '$CONTAINER' is already up to date"
else
	echo "Image '$IMAGE' used in the container '$CONTAINER' has been updated - removing the outdated container"
	docker stop $CONTAINER
	docker rm -f $CONTAINER
fi

