require 'yaml'
require 'fileutils'


required_plugins = %w( vagrant-hostmanager vagrant-vbguest )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

config = {
  local: './config/vagrant-local.yml',
  example: './config/vagrant-local.example.yml'
}

# copy config from example if local config not exists
FileUtils.cp config[:example], config[:local] unless File.exist?(config[:local])
# read config
options = YAML.load_file config[:local]

# check github token
if options['github_token'].nil? || options['github_token'].to_s.length != 40
  options['github_token'] = 0
end

# add all directories in parent folder as domains
vagrant_path = File.dirname(__FILE__)

domains = {}
Dir.chdir("#{vagrant_path}/../") do
  Dir.glob('*').select { |f| File.directory? f
  domains[f]=f unless f == File.basename(vagrant_path)
  }
end

# vagrant configurate
Vagrant.configure(2) do |config|
  # select the box
  config.vm.box = 'bento/ubuntu-16.04'

  # should we ask about box updates?
  config.vm.box_check_update = options['box_check_update']

  config.vm.provider 'virtualbox' do |vb|
    # machine cpus count
    vb.cpus = options['cpus']
    # machine memory size
    vb.memory = options['memory']
    # machine name (for VirtualBox UI)
    vb.name = options['machine_name']
  end

  # machine name (for vagrant console)
  config.vm.define options['machine_name']

  # machine name (for guest machine console)
  config.vm.hostname = options['machine_name']

  # network settings
  config.vm.network 'private_network', ip: options['ip']

  # sync: parent folder of vagrant setup (host machine) -> folder '/app' (guest machine)
  config.vm.synced_folder '../', '/app', owner: 'vagrant', group: 'vagrant'

  # disable folder '/vagrant' (guest machine)
  config.vm.synced_folder '..', '/vagrant', disabled: true

  # hosts settings (host machine)
  config.vm.provision :hostmanager
  config.hostmanager.enabled            = true
  config.hostmanager.manage_host        = true
  config.hostmanager.ignore_private_ip  = false
  config.hostmanager.include_offline    = true
  config.hostmanager.aliases            = domains.values

  # provisioners
  config.vm.provision 'shell', path: './provision/once-as-root.sh', args: [options['timezone']]
  config.vm.provision 'shell', path: './provision/once-as-vagrant.sh', args: [options['github_token']], privileged: false
  config.vm.provision 'shell', path: './provision/always-as-root.sh', run: 'always'
  options['databases'].each do |db|
    config.vm.provision 'shell', path: './provision/create-database.sh', args: [db], run: 'always'
  end


  # post-install message (vagrant console)
  motd = ''
  domains.values.each do |domain|
    config.vm.provision 'shell', path: './provision/create-nginx-config.sh', args: [domain], privileged: false, run: 'always'
    motd = motd + domain + "\n"
  end
  config.vm.post_up_message = "Active domains:\n"+motd
end
