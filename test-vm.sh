#!/usr/bin/env bash
# Boykisser Linux — boot the ISO in QEMU for testing :3
# UEFI by default (modern). Use  ./test-vm.sh --bios  for legacy BIOS testing.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ISO="${1:-$HERE/boykisser-linux-amd64.iso}"
[ "${1:-}" = "--bios" ] && { MODE=bios; ISO="$HERE/boykisser-linux-amd64.iso"; } || MODE=uefi
[ "${2:-}" = "--bios" ] && MODE=bios

if [ ! -f "$ISO" ]; then
	echo "!! ISO not found: $ISO  (run ./build.sh first)" >&2
	exit 1
fi

# KVM acceleration if available
ACCEL=()
if [ -w /dev/kvm ]; then ACCEL=(-enable-kvm -cpu host); else
	echo ":3 (no /dev/kvm — running without acceleration, will be slow)"
	ACCEL=(-cpu max)
fi

# Locate OVMF (UEFI firmware)
OVMF=""
for c in \
	/usr/share/edk2/ovmf/OVMF_CODE.fd \
	/usr/share/OVMF/OVMF_CODE.fd \
	/usr/share/edk2-ovmf/x64/OVMF_CODE.fd ; do
	[ -f "$c" ] && { OVMF="$c"; break; }
done

COMMON=(
	-m 4096
	-smp 4
	-machine q35
	"${ACCEL[@]}"
	-vga virtio
	-display gtk,gl=on
	-device intel-hda -device hda-duplex
	-netdev user,id=net0 -device virtio-net,netdev=net0
	-boot d
	-cdrom "$ISO"
	-name "Boykisser Linux :3"
)

if [ "$MODE" = "uefi" ] && [ -n "$OVMF" ]; then
	echo ":3 booting Boykisser Linux in UEFI mode..."
	# writable copy of the UEFI vars
	VARS="$(mktemp /tmp/boykisser-ovmf-vars.XXXXXX.fd)"
	for v in \
		/usr/share/edk2/ovmf/OVMF_VARS.fd \
		/usr/share/OVMF/OVMF_VARS.fd \
		/usr/share/edk2-ovmf/x64/OVMF_VARS.fd ; do
		[ -f "$v" ] && { cp "$v" "$VARS"; break; }
	done
	exec qemu-system-x86_64 \
		-drive if=pflash,format=raw,readonly=on,file="$OVMF" \
		-drive if=pflash,format=raw,file="$VARS" \
		"${COMMON[@]}"
else
	[ "$MODE" = "uefi" ] && echo ":3 (no OVMF found — falling back to BIOS)"
	echo ":3 booting Boykisser Linux in BIOS mode..."
	exec qemu-system-x86_64 "${COMMON[@]}"
fi
