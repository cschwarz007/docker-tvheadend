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
APP_NAME="tvheadend"
docker build --tag "$APP_NAME" .

if confirm_action "Test image?"; then
	# Set up temporary directories
	TMP_DATA_DIR=$(mktemp -d "/tmp/$APP_NAME-DATA-XXXXXXXXXX")
	add_cleanup "rm -rf $TMP_DATA_DIR"
	TMP_REC_DIR=$(mktemp -d "/tmp/$APP_NAME-REC-XXXXXXXXXX")
	add_cleanup "rm -rf $TMP_REC_DIR"

	# Apply permissions, UID matches process user
	extract_var APP_UID "./Dockerfile" "\K\d+"
	chown -R "$APP_UID":"$APP_UID" "$TMP_DATA_DIR" "$TMP_REC_DIR"

	# Start the test
	extract_var DATA_DIR "./Dockerfile" "\"\K[^\"]+"
	docker run \
	--rm \
	--interactive \
	--publish 9981:9981/tcp \
	--publish 9982:9982/tcp \
	--mount type=bind,source="$TMP_DATA_DIR",target="$DATA_DIR" \
	--mount type=bind,source="$TMP_REC_DIR",target="/mnt/rec" \
	--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
	--name "$APP_NAME" \
	"$APP_NAME"
fi