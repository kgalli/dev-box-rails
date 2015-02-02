# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box      = 'ubuntu/trusty64'
  config.vm.hostname = 'ansible-test'

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.synced_folder 'projects', '/vagrant'

  # Note: this line is important for provisioning using ansible
  #       if you have to change this change ansible.inventory_path too
  config.vm.network 'private_network', ip: '10.1.1.3'

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'provisioning/playbook.yml'
  end

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    #vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--name", "ansible-test"]
  end
end
