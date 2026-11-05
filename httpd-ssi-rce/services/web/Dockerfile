# Image name: challenges/web/httpd-ssi-rce
# Converted from vulhub httpd/ssi-rce
# Upstream recipe: vulhub/php:7.4.33-apache (php:7.4-apache + upload.php)
ARG BASE_WEB_PHP_APACHE_IMAGE=base/web-php-apache:latest
FROM ${BASE_WEB_PHP_APACHE_IMAGE}

# The lab is a file-upload endpoint plus the Apache policy that turns an
# uploaded .shtml into a command. The base ships mod_include inside
# apache2-bin already; only the module load and the Directory options are
# missing, so add them as a drop-in conf.d file (the base includes
# /etc/apache2/conf.d/*.conf after its own default.conf, so these options win).
COPY --chmod=0644 ssi.conf /etc/apache2/conf.d/ssi.conf

COPY --chown=ctf:ctf --chmod=0644 upload.php /app/html/upload.php

# The base start.sh requires an index; serve a small landing page.
COPY --chown=ctf:ctf --chmod=0644 index.php /app/html/index.php
