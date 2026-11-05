# Python Unpickle Deserialization Remote Code Execution

Converted from vulhub `python/unpickle`. Base `base/web-flask`, port **5000**.
`spec.flags` declares `/app/flag.txt`, owner `ctf:ctf`, mode `0400`, service
`web`. `hg challenge run` generates the contents and injects them. Nothing in
git is the flag value.

- Tags: RCE, Deserialization
- Dependency sidecars: none

`GET /` base64-decodes the `user` cookie and passes it to `pickle.loads`.
`private/solve.sh` sends a pickle whose `__reduce__` evaluates a dict that reads
`/app/flag.txt`. The upstream reverse-shell exploit is kept as
`private/exp.py` for reference.

From this directory, with `hg` on `PATH`:

```sh
hg challenge lint --path .
hg challenge build --path .
hg challenge run --path .
hg challenge verify --path .
```

Source: [vulhub `python/unpickle`](https://github.com/vulhub/vulhub/tree/master/python/unpickle).
