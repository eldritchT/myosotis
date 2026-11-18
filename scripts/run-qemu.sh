#!/bin/sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
IMAGES="${IMAGES:-${ROOT}/output/images}"

DISPLAY_MODE=${DISPLAY_MODE:-gtk}
AUDIO_BACKEND=${AUDIO_BACKEND:-pa}
SERIAL=stdio
VNC_ARGS=

for arg in "$@"; do
	case "$arg" in
	--headless)
		DISPLAY_MODE=none
		VNC_ARGS="-vnc :1"
		;;
	--no-audio)
		AUDIO_BACKEND=none
		;;
	--gtk)
		DISPLAY_MODE=gtk
		;;
	--sdl)
		DISPLAY_MODE=sdl
		;;
	--fullscreen)
		DISPLAY_MODE="${DISPLAY_MODE},full-screen=on"
		;;
	-h|--help)
		sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
		exit 0
		;;
	*)
		echo "Unknown option: $arg" >&2
		exit 1
		;;
	esac
done

if [ ! -f "${IMAGES}/bzImage" ] || [ ! -f "${IMAGES}/rootfs.ext4" ]; then
	echo "Missing images in ${IMAGES}; run 'make' first." >&2
	exit 1
fi

if [ -w /dev/kvm ]; then
	ACCEL="-enable-kvm -cpu host"
else
	ACCEL="-cpu max"
fi

# shellcheck disable=SC2086
exec qemu-system-x86_64 \
	-machine q35 \
	${ACCEL} \
	-smp 2 \
	-m 1024 \
	-kernel "${IMAGES}/bzImage" \
	-drive "file=${IMAGES}/rootfs.ext4,format=raw,if=virtio" \
	-append "root=/dev/vda rw console=ttyS0 console=tty0 loglevel=7" \
	-device virtio-vga-gl \
	-device virtio-keyboard-pci \
	-device virtio-mouse-pci \
	-device virtio-tablet-pci \
	-audiodev "${AUDIO_BACKEND},id=snd0" \
	-device intel-hda \
	-device hda-duplex,audiodev=snd0 \
	-nic user,model=virtio-net-pci \
	-display "${DISPLAY_MODE},gl=on" \
	${VNC_ARGS} \
	-serial "${SERIAL}"
