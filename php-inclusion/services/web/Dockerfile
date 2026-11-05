# Image name: challenges/web/php-inclusion
ARG BASE_WEB_PHP_APACHE_IMAGE=base/web-php-apache:latest
FROM ${BASE_WEB_PHP_APACHE_IMAGE}

COPY index.php /app/html/index.php
COPY lfi.php /app/html/lfi.php
COPY phpinfo.php /app/html/phpinfo.php
