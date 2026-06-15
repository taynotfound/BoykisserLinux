#!/usr/bin/env bash
# Boykisser Linux build orchestrator :3
# Builds the live ISO inside a privileged Debian (trixie) container.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

IMAGE="boykisser-builder"
NAME="boykisser-linux"

# --- build variant -----------------------------------------------------------
# Default is the full daily-driver ISO. Pass --netinstall (or NETINSTALL=1) for
# a slim ISO: it ships only the base apps and pulls the heavy ones (OBS, VLC,
# codecs, Steam, VS Code, gaming bits + Flatpaks) from the internet on first
# boot via boykisser-postinstall-apps. Needs an internet connection to finish.
NETINSTALL="${NETINSTALL:-0}"
LB_ARGS=()
for arg in "$@"; do
	case "$arg" in
		--netinstall) NETINSTALL=1 ;;
		--full)       NETINSTALL=0 ;;
		*)            LB_ARGS+=("$arg") ;;
	esac
done
set -- "${LB_ARGS[@]+"${LB_ARGS[@]}"}"

EXTRA_LIST="$HERE/config/package-lists/apps-extra.list.chroot"
MARKER="$HERE/config/includes.chroot/etc/boykisser/netinstall"

restore_variant() {
	# Always undo the netinstall tweaks so the working tree stays clean.
	[ -f "$EXTRA_LIST.disabled" ] && mv -f "$EXTRA_LIST.disabled" "$EXTRA_LIST"
	rm -f "$MARKER"
}
trap restore_variant EXIT
restore_variant

if [ "$NETINSTALL" = "1" ]; then
	echo ":3 building the SLIM netinstall variant (needs internet on first boot)"
	# Keep the heavy apps out of the squashfs...
	[ -f "$EXTRA_LIST" ] && mv -f "$EXTRA_LIST" "$EXTRA_LIST.disabled"
	# ...and drop a marker the chroot hooks, the first-boot service AND auto/config
	# look for. auto/config flips --apt-recommends off when it sees this marker,
	# which is the single biggest size lever for keeping the slim ISO <= 1.2 GB.
	mkdir -p "$(dirname "$MARKER")"
	echo "netinstall" > "$MARKER"
else
	echo ":3 building the FULL daily-driver ISO"
fi

# --- pick a container engine --------------------------------------------------
ENGINE="${ENGINE:-}"
if [ -z "$ENGINE" ]; then
	if command -v podman >/dev/null 2>&1; then ENGINE=podman
	elif command -v docker >/dev/null 2>&1; then ENGINE=docker
	else echo "!! need podman or docker" >&2; exit 1; fi
fi
echo ":3 using container engine: $ENGINE"

# --- build the builder image --------------------------------------------------
echo ":3 building the builder image ($IMAGE)..."
$ENGINE build -t "$IMAGE" -f docker/Dockerfile.builder docker/

# --- run live-build inside the container --------------------------------------
echo ":3 starting the live-build run (this takes a while, go get a snack)..."
$ENGINE run --rm -it \
	--privileged \
	--name "${NAME}-build" \
	-v "$HERE":/build:Z \
	-w /build \
	"$IMAGE" \
	-lc '
		set -e
		echo ":3 cleaning previous build state..."
		lb clean --purge || true
		echo ":3 lb config..."
		lb config
		echo ":3 lb build..."
		lb build
	'

# --- report -------------------------------------------------------------------
ISO="$(ls -1 "$HERE"/*.iso 2>/dev/null | head -n1 || true)"
if [ -n "$ISO" ]; then
	# Give a friendly stable name (slim builds get a -netinstall suffix)
	if [ "$NETINSTALL" = "1" ]; then
		FINAL="$HERE/boykisser-linux-netinstall-amd64.iso"
	else
		FINAL="$HERE/boykisser-linux-amd64.iso"
	fi
	mv -f "$ISO" "$FINAL"
	echo ""
	echo ":3 ===================================================="
	echo ":3  Boykisser Linux is ready!"
	echo ":3  ISO: $FINAL"
	du -h "$FINAL" | awk '{print ":3  size: "$1}'
	echo ":3  test it with:  ./test-vm.sh"
	echo ":3 ===================================================="
else
	echo "!! No ISO produced — check build.log" >&2
	exit 1
fi
