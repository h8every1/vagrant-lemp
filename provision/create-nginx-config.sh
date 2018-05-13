#!/usr/bin/env bash

source /app/vagrant/provision/common.sh

#== Import script args ==
sitename=$(echo "$1")

configs_path="/app/vagrant/nginx"
template_file="${configs_path}/project.conf.template"
config_file="${configs_path}/sites/${sitename}.conf"

if [[ ! -f $config_file ]]
then
    info "Creating nginx config for $sitename"
    cp "$template_file" "$config_file"
    sed -i "s/PROJECT_NAME/$sitename/g" "$config_file"
    info "Done!"
fi
