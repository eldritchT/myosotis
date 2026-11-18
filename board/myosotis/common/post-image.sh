#!/bin/sh
set -eu

BINARIES_DIR="$1"

cat > "${BINARIES_DIR}/run-myosotis.sh" <<'EOF'
#!/bin/sh
set -eu
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
AUDIO_BACKEND=${AUDIO_BACKEND:-pa}
DISPLAY_MODE=${DISPLAY_MODE:-gtk}

set -- \
	-machine q35 -cpu max -smp 2 -m 1024 \
	-kernel "${DIR}/bzImage" \
	-drive "file=${DIR}/rootfs.ext4,format=raw,if=virtio" \
	-append "root=/dev/vda rw console=ttyS0 console=tty0 loglevel=7" \
	-device virtio-vga \
	-device virtio-keyboard-pci \
	-device virtio-mouse-pci \
	-device virtio-tablet-pci \
	-audiodev "${AUDIO_BACKEND},id=snd0" \
	-device intel-hda \
	-device hda-duplex,audiodev=snd0 \
	-nic user,model=virtio-net-pci

if [ "${DISPLAY_MODE}" = "none" ]; then
	set -- "$@" -display none -vnc :1
else
	set -- "$@" -display "${DISPLAY_MODE}"
fi

exec qemu-system-x86_64 "$@"
EOF
chmod 0755 "${BINARIES_DIR}/run-myosotis.sh"

echo
echo "Image ready:"
echo "  kernel : ${BINARIES_DIR}/bzImage"
echo "  rootfs : ${BINARIES_DIR}/rootfs.ext4"
echo "  runner : ${BINARIES_DIR}/run-myosotis.sh"
echo
