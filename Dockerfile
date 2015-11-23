FROM soletic/ssh-chroot
MAINTAINER Sol&TIC <serveur@soletic.org>

RUN apt-get update && \
  apt-get -y install software-properties-common python-software-properties && \
  add-apt-repository -y ppa:ondrej/php5-5.6

# APACHE / MYSQL
RUN apt-get -y update && \
  apt-get -y install php5-fpm php5 && \
  apt-get -y install php5-mcrypt php5-intl php5-curl && \
  apt-get -y install php5-mysql && \
  apt-get -y install mysql-client

# Environment variables to configure php
ENV PHP_TIME_ZONE "Europe/Paris"
ENV PHP_MEMORY_LIMIT 256M

# ADD FILES TO FILE SYSTEM
RUN mkdir -p /chroot/plugins/webvps
ADD setup.sh /chroot/plugins/webvps/setup.sh
ADD install.conf /chroot/plugins/webvps/install.conf

# MAKE SCRIPT EXCUTABLE
RUN chmod 755 /chroot/plugins/webvps/*.*