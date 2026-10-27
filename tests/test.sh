#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="$ROOT_DIR/app/app.sh"

passed=0
failed=0

run_test() {
    local description="$1"
    shift

    if "$@"; then
        echo "PASS: $description"
        ((passed += 1))
    else
        echo "FAIL: $description" >&2
        ((failed += 1))
    fi
}

expect_success() {
    "$@" >/dev/null 2>&1
}

expect_failure() {
    local expected_code="$1"
    shift

    local actual_code=0
    "$@" >/dev/null 2>&1 || actual_code=$?

    [[ "$actual_code" -eq "$expected_code" ]]
}

expect_output() {
    local expected="$1"
    shift

    local output
    output="$("$@" 2>/dev/null)" || return 1
    [[ "$output" == *"$expected"* ]]
}

# 1. Help displays usage information.
run_test "Help displays usage" \
    expect_output "Usage:" "$APP" help

# 2. System information includes the operating system.
run_test "System info displays operating system" \
    expect_output "Operating system:" "$APP" system-info

# 3. An unknown command returns exit code 2.
run_test "Invalid command returns exit code 2" \
    expect_failure 2 "$APP" invalid-command

# 4. No command is an invalid invocation.
run_test "Missing command returns exit code 2" \
    expect_failure 2 "$APP"

# 5. Missing hostname returns exit code 2.
run_test "Missing host returns exit code 2" \
    expect_failure 2 "$APP" check-host

# 6. Localhost resolves on a normally configured system.
run_test "Valid host localhost resolves" \
    expect_output "resolves successfully" "$APP" check-host localhost

# 7. Missing port returns exit code 2.
run_test "Missing port returns exit code 2" \
    expect_failure 2 "$APP" check-port localhost

# 8. A non-numeric port returns exit code 2.
run_test "Non-numeric port returns exit code 2" \
    expect_failure 2 "$APP" check-port localhost abc

# 9. A port above 65535 returns exit code 2.
run_test "Out-of-range port returns exit code 2" \
    expect_failure 2 "$APP" check-port localhost 65536

echo
echo "Test results: $passed passed, $failed failed."

if (( failed > 0 )); then
    exit 1
fi

exit 0
