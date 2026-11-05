# Apache SSI remote command execution

The challenge serves an upload form at `/upload.php`. It rejects only files
whose extension is `php`, and moves everything else into the document root
without renaming it.

The Apache policy for `/app/html` enables `mod_include` with
`Options Includes` and an `INCLUDES` output filter for `.shtml`. That means an
uploaded `.shtml` is scanned for Server Side Includes server-side, and the
`exec` directive runs a shell command and inlines its output.

## Solve

Upload a file whose name ends in `.shtml` and whose body is:

```
<!--#exec cmd="cat /app/flag.txt" -->
```

Then request `/<name>.shtml`. Apache filters the response and replaces the
directive with the command output, which is the flag.

`private/solve.sh` checks that the upload form is present, uploads
`hg_probe.shtml`, and prints the filtered response.

## Notes

- The flag is at `/app/flag.txt`, owned by `ctf:ctf` with mode `0400`. The
  request is served by a worker running as `ctf`, so the file is readable.
- Uploading a `.php` file is refused, and the base maps `.php` to mod_php, so
  `.shtml` is the way to turn an upload into execution.
- This is a policy challenge: the applicaton has the unrestricted upload, and
  the server configuration supplies the execution. The intended fix is to not
  enable `Includes` on a directory that accepts uploads.
