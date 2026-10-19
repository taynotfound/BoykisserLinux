#!/usr/bin/env bash
# Boykisser Linux auto-rebuild :3
# Rebuilds the live ISO whenever Debian ships a new kernel (or other updates),
# so the live image never lags behind on security fixes.
#
# Usage:
#   bk-autobuild.sh                 check for a new kernel; rebuild if needed
#   bk-autobuild.sh --force         rebuild unconditionally
#   bk-autobuild.sh --check         only report whether a rebuild is needed
#   bk-autobuild.sh --install-timer install+enable a weekly systemd user timer
#   bk-autobuild.sh --uninstall-timer remove the timer again
#
# The timer runs weekly (with up to 1h random delay) and only actually rebuilds
# when trixie's linux-image-amd64 candidate version changed since the last
# successful build. State lives in .autobuild-state, logs in autobuild.log.
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$HERE"

STATE="$HERE/.autobuild-state"
LOG="$HERE/autobuild.log"
UNIT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

log() { echo "[$(date -u '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"; }

# --- pick a container engine ---------------------------------------------------
engine() {
	if command -v podman >/dev/null 2>&1; then echo podman
	elif command -v docker >/dev/null 2>&1; then echo docker
	else echo "!! need podman or docker" >&2; exit 1; fi
}

# --- what kernel would a build ship right now? ---------------------------------
latest_kernel() {
	local eng; eng="$(engine)"
	$eng run --rm docker.io/library/debian:trixie-slim bash -c '
		apt-get update -qq >/dev/null 2>&1
		apt-cache policy linux-image-amd64 | awk "/Candidate:/{print \$2}"
	'
}

install_timer() {
	mkdir -p "$UNIT_DIR"
	cat > "$UNIT_DIR/boykisser-rebuild.service" <<EOF
[Unit]
Description=Boykisser Linux weekly live-image rebuild :3

[Service]
Type=oneshot
ExecStart=$HERE/tools/bk-autobuild.sh
WorkingDirectory=$HERE
Nice=10
IOSchedulingClass=idle
EOF
	cat > "$UNIT_DIR/boykisser-rebuild.timer" <<EOF
[Unit]
Description=Rebuild the Boykisser Linux live ISO weekly (new kernel/updates)

[Timer]
OnCalendar=weekly
RandomizedDelaySec=1h
Persistent=true

[Install]
WantedBy=timers.target
EOF
	systemctl --user daemon-reload
	systemctl --user enable --now boykisser-rebuild.timer
	echo ":3 weekly rebuild timer installed and enabled"
	systemctl --user list-timers boykisser-rebuild.timer --no-pager || true
	exit 0
}

uninstall_timer() {
	systemctl --user disable --now boykisser-rebuild.timer 2>/dev/null || true
	rm -f "$UNIT_DIR/boykisser-rebuild.service" "$UNIT_DIR/boykisser-rebuild.timer"
	systemctl --user daemon-reload
	echo ":3 rebuild timer removed"
	exit 0
}

FORCE=0 CHECK=0
for arg in "$@"; do
	case "$arg" in
		--force)           FORCE=1 ;;
		--check)           CHECK=1 ;;
		--install-timer)   install_timer ;;
		--uninstall-timer) uninstall_timer ;;
		*) echo "unknown option: $arg" >&2; exit 2 ;;
	esac
done

log "checking trixie for a new kernel..."
CURRENT="$(latest_kernel)"
[ -n "$CURRENT" ] || { log "!! could not determine candidate kernel"; exit 1; }
LAST="$(cat "$STATE" 2>/dev/null || echo none)"
log "candidate kernel: $CURRENT (last built: $LAST)"

if [ "$CHECK" = 1 ]; then
	[ "$CURRENT" != "$LAST" ] && echo "rebuild needed" || echo "up to date"
	exit 0
fi

if [ "$CURRENT" = "$LAST" ] && [ "$FORCE" != 1 ]; then
	log "up to date  -  nothing to do :3"
	exit 0
fi

log "rebuilding the live ISO (kernel $LAST -> $CURRENT)..."
if ./build.sh </dev/null >>"$LOG" 2>&1; then
	echo "$CURRENT" > "$STATE"
	log ":3 rebuild succeeded  -  ISO refreshed with kernel $CURRENT"
	command -v notify-send >/dev/null 2>&1 && \
		notify-send "Boykisser Linux" "Live ISO rebuilt with kernel $CURRENT :3" || true
else
	log "!! rebuild FAILED  -  see $LOG"
	command -v notify-send >/dev/null 2>&1 && \
		notify-send -u critical "Boykisser Linux" "Weekly ISO rebuild failed  -  check autobuild.log" || true
	exit 1
fi
