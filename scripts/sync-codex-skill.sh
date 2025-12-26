#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/HelloAgents"
TARGET_DIR="${CODEX_HOME:-$HOME/.codex}/skills/helloagents"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "ERROR: Source skill directory not found: $SOURCE_DIR" >&2
  exit 1
fi

mkdir -p "$(dirname "$TARGET_DIR")"

if [[ -L "$TARGET_DIR" ]]; then
  echo "Found symlink at $TARGET_DIR -> $(readlink "$TARGET_DIR")"
  echo "Removing symlink to replace with real directory copy..."
  rm "$TARGET_DIR"
fi

mkdir -p "$TARGET_DIR"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete \
    --exclude '.DS_Store' \
    --exclude '.git' \
    "$SOURCE_DIR/" "$TARGET_DIR/"
else
  echo "WARNING: rsync not found; falling back to cp (no delete sync)." >&2
  cp -R "$SOURCE_DIR/." "$TARGET_DIR/"
fi

echo "Synced Codex skill:"
echo "  from: $SOURCE_DIR"
echo "    to: $TARGET_DIR"
