#!/bin/sh
set -e -u

APP_NAME="module-builder"
APP_VERSION="1.0"
APP_CREATOR="nelshh @ xda-developers"
APP_CREATOR_EMAIL="henrik@cliffords.nu"

export HOME=/home/builder
export USER=builder

REPOROOT="$(dirname $(readlink -f $0))/../"

IMAGE_NAME=nelshh/module-builder
: ${CONTAINER_NAME:=nelshh-module-builder}

echo "\033[1m\033[38;5;4m$APP_NAME v$APP_VERSION\033[m\033[38;5;15m - \033[m\033[1mby $APP_CREATOR [$APP_CREATOR_EMAIL]\033[1m\n"
echo "Running container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."

docker start $CONTAINER_NAME > /dev/null 2> /dev/null || {
	echo "Creating new container..."
	docker run  \
		--detach \
		--name $CONTAINER_NAME \
		--volume $REPOROOT:$HOME/magisk-modules \
		--tty \
		$IMAGE_NAME

	if [ $(id -u) -ne 1000 -a $(id -u) -ne 0 ]
	then
		echo "Changed builder uid/gid... (this may take a while)"
		docker exec --tty $CONTAINER_NAME sudo chown -R $(id -u) $HOME
		docker exec --tty $CONTAINER_NAME sudo chown -R $(id -u) /data
		docker exec --tty $CONTAINER_NAME sudo usermod -u $(id -u) builder
		docker exec --tty $CONTAINER_NAME sudo groupmod -g $(id -g) builder
	fi
}

if [ "$#" -eq  "0" ]; then
	docker exec --interactive --tty $CONTAINER_NAME bash
else
	docker exec --interactive --tty $CONTAINER_NAME $@
fi



