# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box      = 'ubuntu/trusty64'
  config.vm.hostname = 'dev-box-rails'

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.synced_folder 'projects', '/vagrant'
  #config.vm.network 'private_network', ip: '10.1.1.2'

  config.vm.provision :shell, path: 'bootstrap.sh', privileged: false, keep_color: true
end
