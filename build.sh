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
LITE="${LITE:-0}"
CLEAN_MODE="${CLEAN_MODE:-normal}"   # normal | purge | fast
LB_ARGS=()
for arg in "$@"; do
	case "$arg" in
		--netinstall) NETINSTALL=1 ;;
		--full)       NETINSTALL=0; LITE=0 ;;
		--lite)       LITE=1 ;;
		--clean)      CLEAN_MODE=purge ;;   # deep clean: also wipes the package cache
		--fast)       CLEAN_MODE=fast ;;    # incremental: keep the chroot, rebuild binary only
		*)            LB_ARGS+=("$arg") ;;
	esac
done
set -- "${LB_ARGS[@]+"${LB_ARGS[@]}"}"

EXTRA_LIST="$HERE/config/package-lists/apps-extra.list.chroot"
MARKER="$HERE/config/includes.chroot/etc/boykisser/netinstall"
LITE_MARKER="$HERE/config/includes.chroot/etc/boykisser/lite"

restore_variant() {
	# Always undo the netinstall/lite tweaks so the working tree stays clean.
	[ -f "$EXTRA_LIST.disabled" ] && mv -f "$EXTRA_LIST.disabled" "$EXTRA_LIST"
	rm -f "$MARKER" "$LITE_MARKER"
}
trap restore_variant EXIT
restore_variant

if [ "$LITE" = "1" ]; then
	echo ":3 building the LITE variant for ancient BIOS boxes (syslinux only, no heavy apps)"
	[ -f "$EXTRA_LIST" ] && mv -f "$EXTRA_LIST" "$EXTRA_LIST.disabled"
	mkdir -p "$(dirname "$LITE_MARKER")"
	echo "lite" > "$LITE_MARKER"
elif [ "$NETINSTALL" = "1" ]; then
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
# Cleaning strategy (the package cache in cache/ makes rebuilds MUCH faster):
#   normal (default)  lb clean           -  fresh chroot+binary, keeps downloaded debs
#   purge  (--clean)  lb clean --purge   -  everything from scratch, incl. the deb cache
#   fast   (--fast)   lb clean --binary  -  keep the built chroot, regenerate the ISO only
#                     (use after tweaking includes.binary/bootloaders; NOT after
#                     changing package lists or chroot hooks)
case "$CLEAN_MODE" in
	purge) CLEAN_CMD="lb clean --purge" ;;
	fast)  CLEAN_CMD="lb clean --binary" ;;
	*)     CLEAN_CMD="lb clean" ;;
esac
echo ":3 clean mode: $CLEAN_MODE ($CLEAN_CMD)"
# Only allocate a TTY when we have one (the weekly auto-rebuild timer doesn't).
TTY_FLAGS="-i"
[ -t 0 ] && TTY_FLAGS="-it"
$ENGINE run --rm $TTY_FLAGS \
	--privileged \
	--name "${NAME}-build" \
	-e CLEAN_CMD="$CLEAN_CMD" \
	-v "$HERE":/build:Z \
	-w /build \
	"$IMAGE" \
	-lc '
		set -e
		echo ":3 cleaning previous build state ($CLEAN_CMD)..."
		$CLEAN_CMD || true
		echo ":3 lb config..."
		lb config
		echo ":3 lb build..."
		lb build
	' 2>&1 | tee build.log

# --- report -------------------------------------------------------------------
ISO="$(ls -1 "$HERE"/live-image-*.iso 2>/dev/null | head -n1 || true)"
if [ -n "$ISO" ]; then
	# Give a friendly stable name (slim builds get a -netinstall suffix)
	if [ "$LITE" = "1" ]; then
		FINAL="$HERE/boykisser-linux-lite-amd64.iso"
	elif [ "$NETINSTALL" = "1" ]; then
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
	echo "!! No ISO produced  -  check build.log" >&2
	exit 1
fi
