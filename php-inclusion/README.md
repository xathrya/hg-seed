# PHP Local File Inclusion RCE with PHPINFO

Converted from vulhub `php/inclusion`. Base `base/web-php-apache`, port **80**.
`spec.flags` declares `/app/flag.txt`, owner `ctf:ctf`, mode `0400`, service
`web`. `hg challenge run` generates the contents and injects them. Nothing in
git is the flag value.

- Tags: RCE, Path Traversal
- Dependency sidecars: none

`lfi.php` runs `include $_GET['file']` with no validation, so any readable path
is included. `private/solve.sh` confirms the inclusion with `/etc/passwd`, then
includes `/app/flag.txt`. The upstream phpinfo RCE race is kept as
`private/exp.py` for reference.

From this directory, with `hg` on `PATH`:

```sh
hg challenge lint --path .
hg challenge build --path .
hg challenge run --path .
hg challenge verify --path .
```

Source: [vulhub `php/inclusion`](https://github.com/vulhub/vulhub/tree/master/php/inclusion).
