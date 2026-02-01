#!/usr/bin/env bash
set -euo pipefail

# Idempotent: safe to run repeatedly.
# - Creates target dir if missing
# - Removes stale symlinks that point into SOURCE_DIR
# - Recreates/updates symlinks for all layouts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/../amethyst/Layouts"
TARGET_DIR="$HOME/Library/Application Support/Amethyst/Layouts"

if [ ! -d "$SOURCE_DIR" ]; then
  exit 0
fi

mkdir -p "$TARGET_DIR"

for target in "$TARGET_DIR"/*.js; do
  [ -e "$target" ] || continue
  if [ -L "$target" ]; then
    resolved="$(readlink "$target")"
    if [[ "$resolved" == "$SOURCE_DIR"/* ]] && [ ! -e "$resolved" ]; then
      rm "$target"
    fi
  fi
done

for layout in "$SOURCE_DIR"/*.js; do
  [ -e "$layout" ] || continue
  ln -sfn "$layout" "$TARGET_DIR/$(basename "$layout")"
done

