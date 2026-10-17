#!/usr/bin/env bash

set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "=================================="
echo "Stage 1: Validate"
echo "=================================="
bash scripts/lint.sh

echo
echo "=================================="
echo "Stage 2: Test"
echo "=================================="
bash tests/test.sh

echo
echo "=================================="
echo "Stage 3: Docker"
echo "=================================="
bash scripts/build.sh

echo
echo "All local CI stages passed."
