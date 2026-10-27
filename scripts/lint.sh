#!/usr/bin/env bash

set -eu

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_files=(
    README.md
    app/app.sh
    scripts/lint.sh
    scripts/build.sh
    tests/test.sh
    .github/workflows/ci.yml
    Dockerfile
    compose.yaml
    .dockerignore
    grade.sh
)

for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "FAIL: Required file is missing: $file" >&2
        exit 1
    fi
done

echo "PASS: All required files exist."

bash_scripts=(
    app/app.sh
    scripts/lint.sh
    scripts/build.sh
    tests/test.sh
    grade.sh
)

for file in "${bash_scripts[@]}"; do
    if ! bash -n "$file"; then
        echo "FAIL: Bash syntax error in $file" >&2
        exit 1
    fi
    echo "PASS: Syntax check passed for $file."
done

echo "Lint validation completed successfully."
