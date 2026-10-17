#!/usr/bin/env bash

set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

IMAGE_NAME="devops-tool"

echo "Building Docker image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" .

echo "Smoke test 1: help"
docker run --rm "$IMAGE_NAME" help

echo "Smoke test 2: system-info"
docker run --rm "$IMAGE_NAME" system-info

echo "Smoke test 3: invalid command"
status=0
docker run --rm "$IMAGE_NAME" invalid-command >/dev/null 2>&1 || status=$?

if [[ "$status" -ne 2 ]]; then
    echo "FAIL: Expected invalid command to return exit code 2, got $status." >&2
    exit 1
fi

echo "PASS: Invalid command returned exit code 2."
echo "Docker build and smoke tests completed successfully."
