#!/bin/bash

echo "Setup..."

# php conf
sed -ri -e "s/^memory_limit.*/memory_limit = ${PHP_MEMORY_LIMIT}/" \
    -e "s/^;date\.timezone.*/date.timezone = $(echo ${PHP_TIME_ZONE} | sed -e 's/\//\\\//g')/" /etc/php5/cli/php.ini
sed -ri -e "s/^date\.timezone.*/date.timezone = $(echo ${PHP_TIME_ZONE} | sed -e 's/\//\\\//g')/" /etc/php5/cli/php.ini
