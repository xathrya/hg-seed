# Python unpickle deserialization RCE

`GET /` reads the `user` cookie, base64-decodes it, and passes the bytes to
`pickle.loads`. A failed parse falls back to `Guest`. The flag is `/app/flag.txt`,
owned by `ctf` and mode `0400`, which the Flask worker (`ctf`) can read.

`pickle.loads` on attacker input is remote code execution. The upstream
`private/exp.py` uses this to open a reverse shell. The solver adapts the same
idea without a shell: it builds a pickle whose `__reduce__` returns
`(eval, (dict_literal,))`, so deserialization evaluates a dict and the app's
`user["username"]` subscript returns the result. The dict value runs
`os.popen("cat /app/flag.txt").read()`.

`private/solve.sh` first proves the primitive with a harmless dict, then sends
the flag-reading payload and prints the response.
