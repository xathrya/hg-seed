# flask-ssti

A Flask app greets whoever passes `name` on the query string. That value is concatenated into a Jinja template and rendered.

The image is `challenges/web/flask-ssti`, built `FROM base/web-flask`. It listens on port **5000**. `spec.flags` declares `/app/flag.txt`, owner `ctf:ctf`, mode `0400`, on service `web`. `hg challenge run` generates the contents and injects them. Nothing in git is the flag value.

From this directory, with `hg` on `PATH`:

```sh
hg challenge build
hg challenge run
```

The command prints the URL, the generated flag, and the container name. The host port is chosen when the container starts, so use the URL from that output:

```text
http://127.0.0.1:54321
flag hg{0123abcd4567ef89}
hg-flask-ssti-web challenges/web/flask-ssti:local
```

`private/solve.sh` checks that `{{7*7}}` renders as 49, then prints the flag. Point it at the URL from `hg challenge run`:

```sh
CHALLENGE_HOST=127.0.0.1 \
CHALLENGE_PORT=54321 \
CHALLENGE_CONNECTION=http://127.0.0.1:54321 \
  private/solve.sh
hg challenge clean
```
