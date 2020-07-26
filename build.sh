#!/usr/bin/env bash


# Abort on any error
set -e -u

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh

# Check access to docker daemon
assert_dependency "docker"
if ! docker version &> /dev/null; then
	echo "Docker daemon is not running or you have unsufficient permissions!"
	exit -1
fi

# Build the image
APP_NAME="php-fpm-nextcloud"
APP_TAG="hetsh/$APP_NAME"
docker build --tag "$APP_TAG" .

if confirm_action "Test image?"; then
	# Start the test
	docker run \
	--rm \
	--tty \
	--interactive \
	--publish 9000:9000/tcp \
	--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
	--name "$APP_NAME" \
	"$APP_TAG"
fi
