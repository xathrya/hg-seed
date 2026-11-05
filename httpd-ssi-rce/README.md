# Apache HTTPD SSI remote command execution

An upload form is served at `/upload.php`. It rejects only the `php`
extension, so any other file lands in the document root unchanged. Apache is
configured with `mod_include` and `Options Includes` on `/app/html`, so an
uploaded `.shtml` runs `<!--#exec cmd="..." -->` and inlines the output.

The image is `challenges/web/httpd-ssi-rce`, built `FROM base/web-php-apache`.
It listens on port **80**. `spec.flags` declares `/app/flag.txt`, owner
`ctf:ctf`, mode `0400`, on service `web`. `hg challenge run` generates the
contents and injects them. Nothing in git is the flag value.

From this directory, with `hg` on `PATH`:

```sh
hg challenge build
hg challenge run
```

The command prints the URL, the generated flag, and the container name. The host
port is chosen when the container starts, so use the URL from that output:

```text
http://127.0.0.1:54321
flag hg{0123abcd4567ef89}
hg-httpd-ssi-rce-web challenges/web/httpd-ssi-rce:local
```

`private/solve.sh` uploads a `hg_probe.shtml` that contains
`<!--#exec cmd="cat /app/flag.txt" -->` and prints the filtered response. Point
it at the URL from `hg challenge run`:

```sh
CHALLENGE_HOST=127.0.0.1 \
CHALLENGE_PORT=54321 \
CHALLENGE_CONNECTION=http://127.0.0.1:54321 \
  private/solve.sh
hg challenge clean
```

Source: [vulhub `httpd/ssi-rce`](https://github.com/vulhub/vulhub/tree/master/httpd/ssi-rce).
