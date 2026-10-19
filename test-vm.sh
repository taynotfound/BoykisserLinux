#!/usr/bin/env bash
# Boykisser Linux  -  boot the ISO in QEMU for testing :3
# UEFI by default (modern). Use  ./test-vm.sh --bios  for legacy BIOS testing.
#   --disk         attach vm-disk.img (created on first use, 40G) to test the installer
#   --installed    boot the installed system from vm-disk.img, no ISO
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ISO="$HERE/boykisser-linux-amd64.iso"
MODE=uefi
RAM=4096
CPUS=4
DISK=""
INSTALLED=0

usage() {
	echo "usage: $0 [iso] [--bios] [--disk] [--installed] [--ram MB] [--cpus N]"
	exit 0
}

while [ $# -gt 0 ]; do
	case "$1" in
		--bios) MODE=bios ;;
		--disk) DISK="$HERE/vm-disk.img" ;;
		--installed) DISK="$HERE/vm-disk.img"; INSTALLED=1 ;;
		--ram)  RAM="$2"; shift ;;
		--cpus) CPUS="$2"; shift ;;
		-h|--help) usage ;;
		*)      ISO="$1" ;;
	esac
	shift
done

# Don't ask QEMU for more than the host can give.
AVAIL_MB=$(awk '/MemAvailable/{print int($2/1024)}' /proc/meminfo 2>/dev/null || echo "$RAM")
if [ "$RAM" -gt "$AVAIL_MB" ]; then
	RAM=$(( AVAIL_MB > 2048 ? AVAIL_MB - 512 : 2048 ))
	echo ":3 (not enough free RAM  -  using ${RAM} MB instead)"
fi

if [ "$INSTALLED" = 0 ] && [ ! -f "$ISO" ]; then
	echo "!! ISO not found: $ISO  (run ./build.sh first)" >&2
	exit 1
fi

# KVM acceleration if available
ACCEL=()
if [ -w /dev/kvm ]; then ACCEL=(-enable-kvm -cpu host); else
	echo ":3 (no /dev/kvm  -  running without acceleration, will be slow)"
	ACCEL=(-cpu max)
fi

# Locate OVMF (UEFI firmware)
OVMF=""
for c in \
	/usr/share/edk2/x64/OVMF_CODE.4m.fd \
	/usr/share/edk2/ovmf/OVMF_CODE.fd \
	/usr/share/OVMF/OVMF_CODE.fd \
	/usr/share/edk2-ovmf/x64/OVMF_CODE.fd ; do
	[ -f "$c" ] && { OVMF="$c"; break; }
done

# Some distros (Arch, Fedora) package QEMU's virtio-gpu and GTK UI separately;
# fall back to plain VGA / SDL / VNC instead of failing.
DEVICES="$(qemu-system-x86_64 -device help 2>/dev/null)"
DISPLAYS="$(qemu-system-x86_64 -display help 2>/dev/null)"
if printf '%s' "$DEVICES" | grep -q '"virtio-vga"'; then GFX=(-vga virtio); else GFX=(-device VGA,xres=1280,yres=800); fi
if printf '%s' "$DISPLAYS" | grep -qx gtk; then GFX+=(-display gtk,gl=on)
elif printf '%s' "$DISPLAYS" | grep -qx sdl; then GFX+=(-display sdl)
else GFX+=(-display vnc=127.0.0.1:0); echo ":3 no GTK/SDL display in this QEMU  -  connect a VNC viewer to 127.0.0.1:5900"; fi

COMMON=(
	-m "$RAM"
	-smp "$CPUS"
	-machine q35
	"${ACCEL[@]}"
	"${GFX[@]}"
	-device intel-hda -device hda-duplex
	-netdev user,id=net0 -device virtio-net,netdev=net0
	-name "Boykisser Linux :3"
)
if [ -n "$DISK" ]; then
	if [ ! -f "$DISK" ]; then
		# qemu-img lives in a separate package on some distros; a sparse raw file works too
		if command -v qemu-img >/dev/null 2>&1; then qemu-img create -f qcow2 "$DISK" 40G >/dev/null
		else truncate -s 40G "$DISK"; fi
	fi
	FMT=raw
	[ "$(od -An -c -N3 "$DISK" | tr -d ' ')" = "QFI" ] && FMT=qcow2
	COMMON+=(-drive file="$DISK",if=virtio,format=$FMT)
fi
[ "$INSTALLED" = 0 ] && COMMON+=(-boot d -cdrom "$ISO")

if [ "$MODE" = "uefi" ] && [ -n "$OVMF" ]; then
	echo ":3 booting Boykisser Linux in UEFI mode..."
	# Writable copy of the UEFI vars. With a disk it is kept next to it, so the
	# boot entry the installer writes survives into --installed runs.
	if [ -n "$DISK" ]; then VARS="${DISK%.img}.ovmf-vars.fd"
	else VARS="$(mktemp /tmp/boykisser-ovmf-vars.XXXXXX.fd)"; fi
	[ -s "$VARS" ] || for v in \
		/usr/share/edk2/x64/OVMF_VARS.4m.fd \
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
	[ "$MODE" = "uefi" ] && echo ":3 (no OVMF found  -  falling back to BIOS)"
	echo ":3 booting Boykisser Linux in BIOS mode..."
	exec qemu-system-x86_64 "${COMMON[@]}"
fi
