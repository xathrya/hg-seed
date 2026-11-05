# HunterGround Seed

Seed Contest with starter web challenges covering SSTI, SSI upload RCE,
FastCGI exposure, LFI, and pickle deserialization.

| Order | Challenge | Points |
|-------|-----------|--------|
| 1 | `flask-ssti` — Jinja SSTI via the `name` query parameter | 100 |
| 2 | `php-inclusion` — PHP local file inclusion | 150 |
| 3 | `python-unpickle` — pickle deserialization RCE | 200 |
| 4 | `httpd-ssi-rce` — SSI upload RCE on Apache | 250 |
| 5 | `php-fpm` — exposed FastCGI with `auto_prepend_file` read | 300 |

Each subdirectory with a `challenge.yaml` is a contest challenge.
`spec.challenges` in `contest.yaml` orders them and overrides points.

`.github/workflows/build.yaml` builds every challenge image and pushes it to
GHCR on push to `main`, then commits `image.registry` and `image.digest`.
Each challenge directory has the same workflow for when that challenge is its
own repository. After the run is green, `git pull`, then `hg contest deploy`.

```sh
hg contest lint --path .
hg contest challenges --path .
```

A draft contest (`visibility: draft`) stays unpublished on deploy. Set it to
`published` when the contest should go live.
