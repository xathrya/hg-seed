# PHP-FPM FastCGI Unauthorized Access Leads to Remote Code Execution

Converted from vulhub `php/fpm`. The image is `challenges/web/php-fpm`, built
`FROM base/php`. FastCGI listens on port **9000** with no gateway in front of
it, so the player entry is `web.fastcgi` and the connection is
`nc {host} {port}`. `spec.flags` declares `/app/flag.txt`, owner `ctf:ctf`,
mode `0400`, on service `web`. `hg challenge run` generates the contents and
injects them. Nothing in git is the flag value.

- Tags: RCE, Auth Bypass
- Dependency sidecars: none

A FastCGI request whose `SCRIPT_FILENAME` is `/app/index.php` and whose
`PHP_VALUE` is `auto_prepend_file = /app/flag.txt` makes PHP include the flag
file before the script. The file has no PHP tags, so its contents are written
to the FastCGI stdout. `private/solve.sh` speaks the FastCGI protocol directly
and prints the response.

From this directory, with `hg` on `PATH`:

```sh
hg challenge lint --path .
hg challenge build --path .
hg challenge run --path .
hg challenge solve --path .    # reuse the graph run started
hg challenge verify --path .
```

Source: [vulhub `php/fpm`](https://github.com/vulhub/vulhub/tree/master/php/fpm).
