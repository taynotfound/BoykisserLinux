#!/usr/bin/env bash
# Print the next OS release tag: vMAJOR.MONTH.YY.N
#
#   MAJOR  from the MAJOR_VERSION file (bump it for big rewrites)
#   MONTH  current month, YY current year (UTC)
#   N      release count within the month, starting at 1
#
# N continues across the old vMONTH.YY.N tags, so the first new-style tag of a
# month that already had v10.26.3 is v2.10.26.4. Reads tags from the local
# clone, so fetch tags first (CI checks out with fetch-depth: 0).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAJOR="${MAJOR:-$(tr -d '[:space:]' < "$ROOT/MAJOR_VERSION")}"
MONTH="$(date -u +%-m)"
YEAR="$(date -u +%y)"

last=0
while read -r tag; do
	[ -n "$tag" ] || continue
	n="${tag##*.}"
	[ "$n" -gt "$last" ] && last="$n"
done < <(git -C "$ROOT" tag --list "v${MONTH}.${YEAR}.*" "v*.${MONTH}.${YEAR}.*" \
	| grep -E "^v([0-9]+\.)?${MONTH}\.${YEAR}\.[0-9]+$" || true)

echo "v${MAJOR}.${MONTH}.${YEAR}.$((last + 1))"
