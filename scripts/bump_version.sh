#!/bin/bash
set -e

# Finds the latest vX.Y.Z.W tag and bumps the last digit, then triggers the build workflow.

git pull

# Get latest tag matching v*
LATEST_TAG=$(git describe --tags --match "v*" --abbrev=0 2>/dev/null || echo "v0.0.0.0")

# Strip 'v' prefix
VERSION=${LATEST_TAG#v}

# Split into array by dot
IFS='.' read -ra PARTS <<< "$VERSION"

# Ensure we have 4 parts, pad with 0 if needed
while [ ${#PARTS[@]} -lt 4 ]; do
    PARTS+=("0")
done

# Bump the last part
LAST_IDX=$((${#PARTS[@]}-1))
PARTS[$LAST_IDX]=$((PARTS[$LAST_IDX] + 1))

# Rejoin
NEW_VERSION="v$(IFS=.; echo "${PARTS[*]}")"

echo "Bumping: $LATEST_TAG -> $NEW_VERSION"

# Tag and push
git tag "$NEW_VERSION"
git push origin "$NEW_VERSION"

echo "Tag pushed! The build workflow will now generate release $NEW_VERSION."
