#!/usr/bin/env bash

source /app/vagrant/provision/common.sh

#== Import script args ==
sitename=$(echo "$1")

template_file="/app/vagrant/config/nginx-project.template.conf"
config_file="/app/vagrant/nginx/sites/${sitename}.conf"

if [[ ! -f $config_file ]]
then
    info "Creating nginx config for $sitename"
    cp "$template_file" "$config_file"
    sed -i "s/!!PROJECT_NAME!!/$sitename/g" "$config_file"
    info "Done!"
fi
