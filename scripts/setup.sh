#!/usr/bin/env bash
# setup.sh — Clone and install SkillSpector for local development.
# Usage: setup.sh
# Exit codes: 0=success, 1=python missing, 2=clone fail, 3=install fail

set -euo pipefail

SKILLSPECTOR_DIR="$HOME/skillspector"
REQUIRED_PYTHON_MAJOR=3
REQUIRED_PYTHON_MINOR=12

usage() {
  echo "Usage: $0"
  echo ""
  echo "Clones SkillSpector and installs dependencies for local development."
  echo ""
  echo "Exit codes:"
  echo "  0  Success"
  echo "  1  Python >= 3.12 not found"
  echo "  2  Failed to clone SkillSpector"
  echo "  3  Failed to install dependencies"
  exit 1
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
fi

# Validate Python >= 3.12
if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is not installed" >&2
  exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

if [[ "$PYTHON_MAJOR" -lt "$REQUIRED_PYTHON_MAJOR" ]] || \
   [[ "$PYTHON_MAJOR" -eq "$REQUIRED_PYTHON_MAJOR" && "$PYTHON_MINOR" -lt "$REQUIRED_PYTHON_MINOR" ]]; then
  echo "Error: Python >= ${REQUIRED_PYTHON_MAJOR}.${REQUIRED_PYTHON_MINOR} required, found $PYTHON_VERSION" >&2
  exit 1
fi

echo "Python $PYTHON_VERSION OK"

# Clone SkillSpector if missing
if [[ ! -d "$SKILLSPECTOR_DIR" ]]; then
  echo "Cloning SkillSpector to $SKILLSPECTOR_DIR..."
  if ! git clone https://github.com/nvidia/skillspector.git "$SKILLSPECTOR_DIR"; then
    echo "Error: Failed to clone SkillSpector from GitHub" >&2
    exit 2
  fi
fi

# Install dependencies
echo "Installing dependencies with uv..."
if ! uv sync --project "$SKILLSPECTOR_DIR"; then
  echo "Error: Failed to install SkillSpector dependencies" >&2
  exit 3
fi

echo "SkillSpector setup complete."
exit 0
