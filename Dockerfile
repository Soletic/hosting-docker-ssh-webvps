FROM soletic/ssh-chroot
MAINTAINER Sol&TIC <serveur@soletic.org>

RUN apt-get update && \
  apt-get -y install software-properties-common python-software-properties && \
  add-apt-repository -y ppa:ondrej/php

# APACHE / MYSQL
RUN apt-get -y update && \
  apt-get -y install php5.6-fpm php5.6 && \
  apt-get -y install php5.6-mcrypt php5.6-intl php5.6-curl php5.6-mysql php5.6-gd && \
  apt-get -y install mysql-client

# Addons node and less to compile assets when deploying app
RUN apt-get -y install node-less

# Addons Mongo
RUN apt-get -y update && apt-get -y install php5.6-mongo && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
	echo "deb http://repo.mongodb.org/apt/ubuntu precise/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
	apt-get -y update && apt-get install -y mongodb-org-shell mongodb-org-tools


# Environment variables to configure php
ENV PHP_TIME_ZONE "Europe/Paris"
ENV PHP_MEMORY_LIMIT 256M

# ADD FILES TO FILE SYSTEM
RUN mkdir -p /chroot/plugins/webvps
ADD setup.sh /chroot/plugins/webvps/setup.sh
ADD install.conf /chroot/plugins/webvps/install.conf
RUN chmod 755 /chroot/plugins/webvps/*.*

ADD chroot_init_mysql.sh /root/scripts/chroot_init_mysql.sh
RUN chmod 755 /root/scripts/chroot_init_mysql.sh

RUN rm /etc/mysql/my.cnf
ADD my.cnf /etc/mysql/my.cnf

# Remove cron php and alert
RUN rm -f /etc/cron.d/php5