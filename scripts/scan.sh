#!/usr/bin/env bash
# scan.sh — Run SkillSpector on a skill directory (dev/security gate).
# Usage: scan.sh <skill-path> [--format json|text]
# Exit codes: 0=clean, 1=issues found, 2=prereq missing, 3=scan error

set -euo pipefail

SKILLSPECTOR_DIR="$HOME/skillspector"
REQUIRED_PYTHON_MAJOR=3
REQUIRED_PYTHON_MINOR=12

usage() {
  echo "Usage: $0 <skill-path> [--format json|text|markdown|sarif]"
  echo ""
  echo "Runs SkillSpector scan on a skill directory and outputs the report."
  echo ""
  echo "Arguments:"
  echo "  <skill-path>        Path to the skill directory to scan"
  echo "  --format <format>   Output format (default: json)"
  echo ""
  echo "Exit codes:"
  echo "  0  Clean — no issues found"
  echo "  1  Issues found"
  echo "  2  Prerequisite missing (Python or SkillSpector)"
  echo "  3  Scan error"
  exit 2
}

# Parse arguments
if [[ $# -lt 1 ]]; then
  usage
fi

SKILL_PATH="$1"
shift
FORMAT="json"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --format)
      FORMAT="$2"
      shift 2
      ;;
    *)
      echo "Error: Unknown argument '$1'" >&2
      usage
      ;;
  esac
done

# Validate skill path exists
if [[ ! -d "$SKILL_PATH" ]]; then
  echo "Error: Directory '$SKILL_PATH' does not exist" >&2
  exit 3
fi

# Validate Python >= 3.12
if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is not installed" >&2
  exit 2
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

if [[ "$PYTHON_MAJOR" -lt "$REQUIRED_PYTHON_MAJOR" ]] || \
   [[ "$PYTHON_MAJOR" -eq "$REQUIRED_PYTHON_MAJOR" && "$PYTHON_MINOR" -lt "$REQUIRED_PYTHON_MINOR" ]]; then
  echo "Error: Python >= ${REQUIRED_PYTHON_MAJOR}.${REQUIRED_PYTHON_MINOR} required, found $PYTHON_VERSION" >&2
  exit 2
fi

# Ensure SkillSpector is available
if ! command -v skillspector &>/dev/null; then
  if [[ ! -d "$SKILLSPECTOR_DIR" ]]; then
    echo "SkillSpector not found. Cloning from GitHub..."
    if ! git clone https://github.com/nvidia/skillspector.git "$SKILLSPECTOR_DIR"; then
      echo "Error: Failed to clone SkillSpector from GitHub" >&2
      exit 2
    fi
  fi
  export PATH="$SKILLSPECTOR_DIR:$PATH"
fi

# Run scan
echo "Scanning: $SKILL_PATH (format: $FORMAT)"
SCAN_OUTPUT=$(uv run --project "$SKILLSPECTOR_DIR" skillspector scan "$SKILL_PATH" --no-llm --format "$FORMAT" 2>&1) || {
  SCAN_EXIT=$?
  if [[ $SCAN_EXIT -eq 1 ]]; then
    echo "$SCAN_OUTPUT"
    exit 1
  fi
  echo "Error: Scan failed with exit code $SCAN_EXIT" >&2
  echo "$SCAN_OUTPUT" >&2
  exit 3
}

echo "$SCAN_OUTPUT"

# Check for issues in JSON output
if [[ "$FORMAT" == "json" ]]; then
  ISSUE_COUNT=$(echo "$SCAN_OUTPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
issues = data.get('issues', [])
print(len(issues))
" 2>/dev/null || echo "0")

  if [[ "$ISSUE_COUNT" -gt 0 ]]; then
    exit 1
  fi
fi

exit 0
