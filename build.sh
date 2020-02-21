#!/usr/bin/env bash


# Abort on any error
set -e -u

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh

# Check acces do docker daemon
assert_dependency "docker"
if ! docker version &> /dev/null; then
    echo "Docker daemon is not running or you have unsufficient permissions!"
    exit -1
fi

APP_NAME="php-fpm-nextcloud"
docker build --tag "$APP_NAME" .

if confirm_action "Test image?"; then
	docker run \
	--rm \
	--interactive \
	--publish 9000:9000/tcp \
	--name "$APP_NAME" \
	"$APP_NAME"
fi
