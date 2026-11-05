# Templated hello

`GET /` reads `name` from the query string, concatenates it into `Hello `, and renders that string as a Jinja template. The flag is `/app/flag.txt`, owned by `ctf` and mode `0400`.

A template expression can read that file. `private/solve.sh` first checks that `{{7*7}}` renders as 49, then prints the flag.
