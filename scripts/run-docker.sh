#!/bin/sh
set -e -u

HOME=/home/builder
UNAME=$(uname)
if [ "$UNAME" = Darwin ]; then
	# Workaround for mac readlink not supporting -f.
	REPOROOT=$PWD
else
	REPOROOT="$(dirname $(readlink -f $0))/../"
fi

IMAGE_NAME=nelshh/module-builder
: ${CONTAINER_NAME:=nelshh-module-builder}

USER=builder

echo "module-builder v1.0 - by nelshh @ XDA-developers [henrik@cliffords.nu]"
echo "Running container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."

docker start $CONTAINER_NAME > /dev/null 2> /dev/null || {
	echo "Creating new container..."
	docker run --privileged -it -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker --name $CONTAINER_NAME -d \
		--volume $REPOROOT:$HOME/magisk-modules \
		--tty \
		$IMAGE_NAME
    if [ "$UNAME" != Darwin ]; then
	if [ $(id -u) -ne 1000 -a $(id -u) -ne 0 ]
	then
		echo "Changed builder uid/gid... (this may take a while)"
		docker exec --tty $CONTAINER_NAME sudo chown -R $(id -u) $HOME
		docker exec --tty $CONTAINER_NAME sudo chown -R $(id -u) /data
		docker exec --tty $CONTAINER_NAME sudo usermod -u $(id -u) builder
		docker exec --tty $CONTAINER_NAME sudo groupmod -g $(id -g) builder
	fi
    fi
}

if [ "$#" -eq  "0" ]; then
	docker exec --interactive --tty $CONTAINER_NAME bash
else
	docker exec --interactive --tty $CONTAINER_NAME $@
fi



