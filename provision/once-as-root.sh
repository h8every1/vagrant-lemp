#!/usr/bin/env bash

source /app/vagrant/provision/common.sh

#== Import script args ==

timezone=$(echo "$1")

#== Provision script ==

info "Provision-script user: `whoami`"

export DEBIAN_FRONTEND=noninteractive

info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password

info "Prepare root password for MySQL"
debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password \"''\""
debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password \"''\""
info "Done!"

info "Add PHP 7.1/7.2 repository"
add-apt-repository -y ppa:ondrej/php

info "Update OS software"
apt-get update
apt-get upgrade -y

info "Install additional software"
apt-get install -y php7.1-curl php7.1-xdebug php7.1-cli php7.1-intl php7.1-mysqlnd php7.1-gd php7.1-fpm php7.1-mbstring php7.1-xml php7.1-soap php7.1-ldap unzip nginx mysql-server-5.7 mc

info "Configure MySQL"
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
mysql -uroot <<< "CREATE USER 'root'@'%' IDENTIFIED BY ''"
mysql -uroot <<< "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION"
mysql -uroot <<< "DROP USER 'root'@'localhost'"
mysql -uroot <<< "FLUSH PRIVILEGES"
info "Done!"

info "Configure PHP-FPM"
sed -i 's/user = www-data/user = vagrant/g' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/owner = www-data/owner = vagrant/g' /etc/php/7.1/fpm/pool.d/www.conf
info "Done!"


info "Configure xDebug"
function xdebug_config {
  xdebug_path="/etc/php/$1/mods-available/"
  xdebug_config="${xdebug_path}xdebug.ini"

  if [[ ! -d $xdebug_path ]]; then
    return 1
  fi

  if [[ -f $xdebug_config ]]; then
    mv ${xdebug_config} ${xdebug_config}.bak
  fi

  ln -s /app/vagrant/config/xdebug.ini ${xdebug_config}
}

xdebug_config "5.6"
xdebug_config "7.0"
xdebug_config "7.1"
xdebug_config "7.2"
info "Done!"

info "Configure NGINX"
sed -i 's/user www-data/user vagrant/g' /etc/nginx/nginx.conf
info "Done!"

info "Enabling site configuration"
ln -s /app/vagrant/nginx/app.conf /etc/nginx/sites-enabled/app.conf
info "Done!"


info "Install composer"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
