The flag is the file `/app/flag.txt`.

php-fpm is listening on port 9000 with no gateway in front of it. A FastCGI responder request whose `SCRIPT_FILENAME` is `/app/index.php` and whose `PHP_VALUE` is `auto_prepend_file = /app/flag.txt` makes PHP include the flag file before the script. The file has no PHP tags, so its contents are written to the FastCGI stdout.
