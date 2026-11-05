# Image name: challenges/web/php-fpm
ARG BASE_PHP_IMAGE=base/php:latest
FROM ${BASE_PHP_IMAGE}

# The pool is already running as ctf. Drop the www-data setuid lines so
# php-fpm does not try to change user, and publish FastCGI on 9000.
RUN sed -i \
      -e 's/^user = /;user = /' \
      -e 's/^group = /;group = /' \
      -e 's/^listen.owner = /;listen.owner = /' \
      -e 's/^listen.group = /;listen.group = /' \
      /usr/local/etc/php-fpm.d/www.conf
COPY zzz-hg.conf /usr/local/etc/php-fpm.d/zzz-hg.conf
COPY index.php /app/index.php
COPY --chmod=0755 start.sh /start.sh
