#!/usr/bin/env bash

set -u

usage() {
    cat <<'EOF'
Usage:
  ./app/app.sh system-info
  ./app/app.sh check-host <host>
  ./app/app.sh check-port <host> <port>
  ./app/app.sh help

Commands:
  system-info          Display system information.
  check-host <host>    Check whether a hostname resolves.
  check-port <host> <port>
                       Check TCP connectivity to a host and port.
  help                 Display this help message.
EOF
}

invalid() {
    echo "Error: $1" >&2
    echo "Run './app/app.sh help' for usage." >&2
    exit 2
}

check_host() {
    local host="$1"

    if ! getent hosts "$host" >/dev/null 2>&1; then
        echo "Host '$host' could not be resolved." >&2
        return 1
    fi

    echo "Host '$host' resolves successfully."
}

check_port() {
    local host="$1"
    local port="$2"

    if [[ ! "$port" =~ ^[0-9]+$ ]]; then
        invalid "Port must be numeric."
    fi

    # Remove leading zeroes before range checking, using
    # string manipulation to avoid shell integer overflow.
    local normalized="$port"
    while [[ ${#normalized} -gt 1 && "$normalized" == 0* ]]; do
        normalized="${normalized#0}"
    done

    if [[ ${#normalized} -gt 5 ]] ||
       (( 10#$normalized < 1 || 10#$normalized > 65535 )); then
        invalid "Port must be between 1 and 65535."
    fi

    if ! getent hosts "$host" >/dev/null 2>&1; then
        echo "Host '$host' could not be resolved." >&2
        return 1
    fi

    if timeout 3 bash -c 'echo > /dev/tcp/"$1"/"$2"' _ \
        "$host" "$normalized" 2>/dev/null; then
        echo "TCP connection to $host:$normalized succeeded."
    else
        echo "TCP connection to $host:$normalized failed." >&2
        return 1
    fi
}

if [[ $# -eq 0 ]]; then
    invalid "A command is required."
fi

command="$1"
shift

case "$command" in
    help)
        [[ $# -eq 0 ]] || invalid "help takes no arguments."
        usage
        ;;
    system-info)
        [[ $# -eq 0 ]] || invalid "system-info takes no arguments."
        echo "Operating system: $(uname -s)"
        echo "Hostname: $(hostname)"
        echo "Kernel: $(uname -r)"
        echo "Architecture: $(uname -m)"
        ;;
    check-host)
        [[ $# -eq 1 && -n "$1" ]] ||
            invalid "check-host requires exactly one hostname."
        check_host "$1"
        ;;
    check-port)
        [[ $# -eq 2 && -n "$1" && -n "$2" ]] ||
            invalid "check-port requires a hostname and a port."
        check_port "$1" "$2"
        ;;
    *)
        invalid "Unknown command: $command"
        ;;
esac
