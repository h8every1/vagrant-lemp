#!/usr/bin/env bash

source /app/vagrant/provision/common.sh

#== Import script args ==

github_token=$(echo "$1")

#== Provision script ==

info "Provision-script user: `whoami`"

info "Configure composer"
composer config --global github-oauth.github.com ${github_token}
echo "Done!"

#info "Install plugins for composer"
#composer global require "fxp/composer-asset-plugin:^1.2.0" --no-progress

#info "Install codeception"
#composer global require "codeception/codeception=2.0.*" "codeception/specify=*" "codeception/verify=*" --no-progress
echo 'export PATH=/home/vagrant/.config/composer/vendor/bin:$PATH' | tee -a /home/vagrant/.profile

info "Install project dependencies"
cd /app/safeinet-design
composer --no-progress --prefer-dist install

#info "Init project"
#./init --env=Development --overwrite=y

#info "Apply migrations"
#./yii migrate <<< "yes"

info "Create bash-alias 'app' for vagrant user"
echo 'alias app="cd /app"' | tee /home/vagrant/.bash_aliases

echo 'alias xon="export XDEBUG_CONFIG=\"profiler_enable=1\""' | tee /home/vagrant/.bash_aliases
echo 'alias xoff="export XDEBUG_CONFIG=\"profiler_enable=0\""' | tee /home/vagrant/.bash_aliases

info "Enabling colorized prompt for guest console"
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/" /home/vagrant/.bashrc


info "Updating SSH keys"
if [ -f ../ssh ]
then
  [ -d ~/.ssh ] || mkdir ~/.ssh
  cp /app/vagrant/ssh/* ~/.ssh
  chmod 600 ~/.ssh/config
fi
