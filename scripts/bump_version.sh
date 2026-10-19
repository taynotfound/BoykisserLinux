#!/bin/bash
# Tag and push the next OS release (vMAJOR.MONTH.YY.N, see next-version.sh).
# The build workflow picks up the tag and publishes the ISOs.
set -e

cd "$(dirname "$0")/.."
git pull --tags
NEW_VERSION="$(scripts/next-version.sh)"

echo "Creating release tag: $NEW_VERSION"
git tag "$NEW_VERSION"
git push origin "$NEW_VERSION"
echo "Tag pushed! The build workflow will now generate release $NEW_VERSION."
