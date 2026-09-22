#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BACKEND_SOURCE="$ROOT/repos/backend/target/site/jacoco"
FRONTEND_SOURCE="$ROOT/repos/frontend/coverage"
E2E_SOURCE="$ROOT/repos/frontend/reports/e2e-coverage.md"

BACKEND_DEST="$ROOT/reports/backend-jacoco"
FRONTEND_DEST="$ROOT/reports/frontend-jest"
E2E_DEST="$ROOT/reports/e2e-coverage.md"

require_path() {
  if [ ! -e "$1" ]; then
    echo "Missing report source: $1" >&2
    exit 1
  fi
}

require_path "$BACKEND_SOURCE/index.html"
require_path "$FRONTEND_SOURCE/index.html"
require_path "$E2E_SOURCE"

rm -rf "$BACKEND_DEST" "$FRONTEND_DEST"
mkdir -p "$BACKEND_DEST" "$FRONTEND_DEST" "$ROOT/reports"

cp -R "$BACKEND_SOURCE/." "$BACKEND_DEST/"
cp -R "$FRONTEND_SOURCE/." "$FRONTEND_DEST/"
cp "$E2E_SOURCE" "$E2E_DEST"

echo "Reports exported:"
echo "  $BACKEND_DEST/index.html"
echo "  $FRONTEND_DEST/index.html"
echo "  $E2E_DEST"
