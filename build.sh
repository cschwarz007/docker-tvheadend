#!/usr/bin/env bash


# Abort on any error
set -eu

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

# Build the image
APP_NAME="tvheadend"
docker build --tag "$APP_NAME" .

if confirm_action "Test image?"; then
	docker run \
	--rm \
	--interactive \
	--publish 9981:9981/tcp \
	--publish 9982:9982/tcp \
	--name "$APP_NAME" \
	"$APP_NAME"
fi