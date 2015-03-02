# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.define :icinga do |icinga_config|
    icinga_config.vm.box = "Centos65"
    icinga_config.vm.network "private_network", ip:  "192.168.99.101"
    icinga_config.vm.host_name = "icinga"
    icinga_config.vm.provision :puppet do |icinga_puppet|
      icinga_puppet.manifests_path = "manifests"
      icinga_puppet.module_path = "modules"
      icinga_puppet.manifest_file = "site.pp"
    end
  end  
end
