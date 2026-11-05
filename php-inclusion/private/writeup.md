# PHP local file inclusion

`lfi.php` runs `include $_GET['file']` with no validation, so any readable path
is included. `phpinfo.php` exposes the interpreter state, which is what the
upstream lab uses to turn the LFI into RCE: upload a PHP payload, read the
temporary file name from phpinfo, and include it before PHP deletes it.

The flag is `/app/flag.txt`, owned by `ctf`, and the Apache worker runs as
`ctf`, so the file is readable. `private/solve.sh` confirms the inclusion with
`/etc/passwd` and then includes `/app/flag.txt`, which prints the flag verbatim.

The RCE race (the point of the upstream writeup) is not needed to read a file
that the worker can already read; it is included here as `private/exp.py` for
reference.
