#!/bin/sh
set -eu

TARGET_DIR="$1"

mkdir -p "${TARGET_DIR}/run/user/1000"
chmod 0700 "${TARGET_DIR}/run/user/1000"
chown 1000:1000 "${TARGET_DIR}/run/user/1000"

exit 0