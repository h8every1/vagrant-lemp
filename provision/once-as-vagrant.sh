#!/usr/bin/env bash

source /app/vagrant/provision/common.sh

#== Import script args ==

github_token=$(echo "$1")

#== Provision script ==

info "Provision-script user: `whoami`"


if [[ $github_token ]] && [[ $github_token -ne 0 ]];
then
  info "Configure composer"
  composer config --global github-oauth.github.com ${github_token}
  info "Done!"
else
  info "No github token provided. Composer will ask for it when needed."
fi

#info "Install plugins for composer"
#composer global require "fxp/composer-asset-plugin:^1.2.0" --no-progress

info "Install codeception"
composer global require "codeception/codeception=2.0.*" "codeception/specify=*" "codeception/verify=*" --no-progress

info "Add composer bin to \$PATH"
echo 'export PATH=/home/vagrant/.config/composer/vendor/bin:$PATH' | tee -a /home/vagrant/.profile

info "Create bash-alias 'app' for vagrant user"
echo 'alias app="cd /app"' | tee -a /home/vagrant/.bash_aliases

info "Create bash-alias 'xon' and 'xoff' for vagrant user"
echo 'alias xon="export XDEBUG_CONFIG=\"profiler_enable=1\""' | tee -a /home/vagrant/.bash_aliases
echo 'alias xoff="export XDEBUG_CONFIG=\"profiler_enable=0\""' | tee -a /home/vagrant/.bash_aliases

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc


if [[ -d ../ssh ]]
then
  info "Importing SSH keys"
  [[ -d ~/.ssh ]] || mkdir ~/.ssh
  cp /app/vagrant/ssh/* ~/.ssh

  [[ -f ~/.ssh/config ]] || touch ~/.ssh/config
  chmod 600 ~/.ssh/config
fi
