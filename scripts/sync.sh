#!/usr/bin/env bash
# Agent Skills Junction - Multi-Harness Sync Engine (Linux / macOS)
# Consolidates AI Agent skills into a Single Source of Truth (~/.agents/skills)
# and creates atomic symlinks for all target agent harnesses.

set -euo pipefail

SSOT="${HOME}/.agents/skills"
CONFIG_FILE="$(dirname "$0")/../config/harnesses.json"

echo "================================================================"
echo "          Agent Skills Junction - Sync Engine (POSIX)           "
echo "================================================================"
echo "Central SSOT: ${SSOT}"

mkdir -p "${SSOT}"

# Default targets
TARGETS=(
  "${HOME}/.pi/agent/skills"
  "${HOME}/.codex/skills"
  "${HOME}/.gemini/config/skills"
  "${HOME}/.claude/skills"
  "${HOME}/.continue/skills"
  "${HOME}/.openhands/skills"
)

for target in "${TARGETS[@]}"; do
  echo "Processing target: ${target}"
  mkdir -p "$(dirname "${target}")"

  if [ -L "${target}" ]; then
    echo "  -> [OK] Already a symlink: ${target}"
  elif [ -d "${target}" ]; then
    echo "  -> [MERGE] Physical folder found. Merging unique skills into SSOT..."
    cp -rn "${target}/"* "${SSOT}/" 2>/dev/null || true
    rm -rf "${target}"
    ln -sfn "${SSOT}" "${target}"
    echo "  -> [SUCCESS] Symlink created: ${target} -> ${SSOT}"
  else
    ln -sfn "${SSOT}" "${target}"
    echo "  -> [SUCCESS] Symlink created: ${target} -> ${SSOT}"
  fi
done

echo "================================================================"
echo "All target harnesses successfully symlinked to SSOT!"
echo "================================================================"