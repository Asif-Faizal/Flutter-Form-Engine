#!/usr/bin/env bash
# Run image/media field unit + widget tests and print a short summary.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v flutter >/dev/null 2>&1; then
  echo "error: flutter not found on PATH" >&2
  exit 1
fi

echo "==> flutter pub get"
flutter pub get

echo "==> running media validation + field tests"
flutter test \
  test/media_validation_test.dart \
  test/media_field_test.dart \
  --reporter expanded

echo
echo "All media field tests passed."
echo "Docs: docs/fields/image.md , docs/fields/media.md"
