#!/usr/bin/env bash
# Boykisser Linux build orchestrator :3
# Builds the live ISO inside a privileged Debian (trixie) container.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

IMAGE="boykisser-builder"
NAME="boykisser-linux"

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
	# Give a friendly stable name
	FINAL="$HERE/boykisser-linux-amd64.iso"
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
