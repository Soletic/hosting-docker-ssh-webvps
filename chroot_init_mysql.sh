#!/bin/bash

sshusers_file=${CHROOT_USERS_HOME_DIR}/.sshusers

case "$1" in
	conf)
		# Usage : $0 conf --port|-P <mysqlport> --user|-u <user>
		while [[ $# > 1 ]] 
		do
			key="$1"
			case $key in
				-u|--user)
					user="$2"
					shift # past argument
					;;
				-P|--port)
					port="$2"
					shift # past argument
					;;
				-ip|--mysql-host-ip)
					host_ip="$2"
					shift # past argument
					;;
				*)
					# unknown option
					shift
					;;
			esac
		done
		if [ -z "$user" ] || [ -z "$port" ] || [ -z "$host_ip" ]; then
			>&2 echo "[conf] argument missing. Usage : $0 conf --port|-P <mysqlport> --user|-u <user> -ip|--mysql-host-ip <host_ip>"
			exit 1
		fi
		chroot_dir=${CHROOT_INSTALL_DIR}/$user
		if [ ! -f $chroot_dir/etc/mysql/my.cnf ]; then
			>&2 echo "[conf] $chroot_dir/etc/mysql/my.cnf not found"
			exit 1
		fi

		# PHP mysql client conf
		sed -ri -e "s/^mysql.default_host.*/mysql.default_host=$host_ip/" \
			-e "s/^mysqli.default_host.*/mysqli.default_host=$host_ip/" \
			-e "s/^mysql.default_port.*/mysql.default_port=$port/" \
			-e "s/^mysqli.default_port.*/mysqli.default_port=$port/" $chroot_dir/etc/php5/cli/php.ini

		# Mysql client conf
		sed -ri -e "s/^host=.*/host=$host_ip/" \
			-e "s/^port=.*/port=$port/" $chroot_dir/etc/mysql/my.cnf
		
		;;
	setip)
		
		;;
	*)
		>&2 echo "Command $1 not found. Usage : $0 <command> <options>"
		exit 1
esac