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
  config.vm.network "forwarded_port", guest: 5601, host: 5601 # Kibana
  config.vm.network "forwarded_port", guest: 3000, host: 3000 # App

  # configure provisioning
  config.vm.synced_folder "./provision", "/vagrant"

  # configure provider
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 1
    vb.name = "ubuntu"
    vb.gui = false
    file_to_disk1 = "extradisk1.vmdk"
    file_to_disk2 = "extradisk2.vmdk"
    unless File.exist?(file_to_disk1)
        vb.customize [ "createmedium", "disk", "--filename", "extradisk1.vmdk", "--format", "vmdk", "--size", 1024 * 1 ]
    end
    unless File.exist?(file_to_disk2)
        vb.customize [ "createmedium", "disk", "--filename", "extradisk2.vmdk", "--format", "vmdk", "--size", 1024 * 1 ]
    end
    vb.customize [ "storageattach", "ubuntu" , "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", file_to_disk1]
    vb.customize [ "storageattach", "ubuntu" , "--storagectl", "SCSI", "--port", "3", "--device", "0", "--type", "hdd", "--medium", file_to_disk2]
  end
end
