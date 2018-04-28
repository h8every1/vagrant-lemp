#!/usr/bin/env bash

source /app/vagrant/provision/common.sh

#== Import script args ==

db=$(echo "$1")
info "Adding MySQL database: ${db}"
mysql -uroot <<< "CREATE DATABASE ${db} CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci"
mysql -uroot <<< "CREATE USER '${db}'@'%' IDENTIFIED BY ''"
mysql -uroot <<< "GRANT ALL PRIVILEGES ON ${db}.* TO '${db}'@'%'"
mysql -uroot <<< "FLUSH PRIVILEGES"
echo "Done!"
