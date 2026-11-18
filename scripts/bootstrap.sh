#!/bin/sh

set -eu

VERSION=2026.02.3
SHA256=5a59e7501b0b4ec52c41f4bfa79412320e0b37eae5f719605a258e8d0c6fc7fb
URL="https://buildroot.org/downloads/buildroot-${VERSION}.tar.xz"

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TARBALL="${ROOT}/buildroot-${VERSION}.tar.xz"
BUILDROOT="${ROOT}/buildroot"

if [ -f "${BUILDROOT}/Makefile" ]; then
	echo "Buildroot already present in ${BUILDROOT}"
	exit 0
fi

if [ ! -f "${TARBALL}" ]; then
	echo "Downloading Buildroot ${VERSION}..."
	curl -fL --output "${TARBALL}.part" "${URL}"
	mv "${TARBALL}.part" "${TARBALL}"
fi

echo "${SHA256}  ${TARBALL}" | sha256sum -c -

echo "Extracting Buildroot ${VERSION}..."
rm -rf "${BUILDROOT}.tmp"
mkdir -p "${BUILDROOT}.tmp"
tar -xf "${TARBALL}" -C "${BUILDROOT}.tmp" --strip-components=1
mv "${BUILDROOT}.tmp" "${BUILDROOT}"
rm -f "${TARBALL}"

echo "Buildroot ${VERSION} is ready."
