# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "ubuntu"
  config.vm.box_check_update = false

  # configure bash script
  config.vm.provision "shell", path: "bootstrap.sh"

  # configure network ports
  config.vm.network "forwarded_port", guest: 9200, host: 9200 # Elasticsearch

  # configure provisioning
  config.vm.synced_folder "./provision", "/vagrant"

  # configure provider
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 1
    vb.gui = false
  end
end
