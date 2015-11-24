#!/bin/bash

echo "Setup..."

host_ip=$(/sbin/ip route|awk '/default/ { print $3 }')

# php conf
sed -ri -e "s/^memory_limit.*/memory_limit = ${PHP_MEMORY_LIMIT}/" \
    -e "s/^;date\.timezone.*/date.timezone = $(echo ${PHP_TIME_ZONE} | sed -e 's/\//\\\//g')/" /etc/php5/cli/php.ini
sed -ri -e "s/^date\.timezone.*/date.timezone = $(echo ${PHP_TIME_ZONE} | sed -e 's/\//\\\//g')/" /etc/php5/cli/php.ini
sed -ri -e "s/^mysql.default_host.*/mysql.default_host=$host_ip/" \
	-e "s/^mysqli.default_host.*/mysqli.default_host=$host_ip/" /etc/php5/cli/php.ini

# mysql conf
sed -ri -e "s/^host=$/host=$host_ip/" /etc/mysql/my.cnf
