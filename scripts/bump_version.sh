#!/bin/bash
set -e

# Creates the next vM.YY.revision release tag for the current month.

git pull

MONTH=$(date -u +%-m)
YEAR=$(date -u +%y)
REVISION=0
while read -r tag; do
    if [[ "$tag" =~ ^v${MONTH}\.${YEAR}\.[0-9]+$ ]]; then
        REVISION=${tag##*.}
        break
    fi
done < <(git tag --list "v${MONTH}.${YEAR}.*" --sort=-version:refname)
NEW_VERSION="v${MONTH}.${YEAR}.$((REVISION + 1))"

echo "Creating release tag: $NEW_VERSION"

# Tag and push
git tag "$NEW_VERSION"
git push origin "$NEW_VERSION"

echo "Tag pushed! The build workflow will now generate release $NEW_VERSION."
