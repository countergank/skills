#!/usr/bin/env bash
# scan-all.sh — Scan all skills in the repository (dev/security gate).
# Usage: scan-all.sh [--format json|text]
# Depends on: scan.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_ROOT/skills"
SCAN_SCRIPT="$SCRIPT_DIR/scan.sh"

usage() {
  echo "Usage: $0 [--format json|text]"
  echo ""
  echo "Scans all skill directories under skills/ using scan.sh."
  echo ""
  echo "Arguments:"
  echo "  --format <format>   Output format (default: json)"
  echo ""
  echo "Exit codes:"
  echo "  0  All scans clean"
  echo "  1  One or more scans found issues"
  echo "  2  Prerequisite missing"
  echo "  3  Scan error"
  exit 2
}

# Parse arguments
FORMAT="json"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --format)
      FORMAT="$2"
      shift 2
      ;;
    --help|-h)
      usage
      ;;
    *)
      echo "Error: Unknown argument '$1'" >&2
      usage
      ;;
  esac
done

# Check skills directory exists
if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "No skills directory found at $SKILLS_DIR"
  exit 0
fi

# Collect skill directories
SKILLS=()
for dir in "$SKILLS_DIR"/*/; do
  [[ -d "$dir" ]] && SKILLS+=("$(basename "$dir")")
done

# Handle empty skills directory
if [[ ${#SKILLS[@]} -eq 0 ]]; then
  echo "No skills found in $SKILLS_DIR"
  exit 0
fi

# Sort alphabetically
IFS=$'\n' SKILLS=($(sort <<<"${SKILLS[*]}")); unset IFS

echo "Scanning ${#SKILLS[@]} skill(s)..."
echo "---"

OVERALL_EXIT=0
for skill in "${SKILLS[@]}"; do
  echo ""
  echo "=== $skill ==="
  if ! "$SCAN_SCRIPT" "$SKILLS_DIR/$skill" --format "$FORMAT"; then
    EXIT_CODE=$?
    if [[ $EXIT_CODE -gt $OVERALL_EXIT ]]; then
      OVERALL_EXIT=$EXIT_CODE
    fi
  fi
done

echo ""
echo "---"
echo "Scan complete. ${#SKILLS[@]} skill(s) processed."
exit $OVERALL_EXIT
