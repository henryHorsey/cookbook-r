# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "test-server-1"

  config.vm.box = "ubuntu/trusty64"
  #config.vm.box = "centos65-x86_64"
  #config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box"

  config.vm.network :private_network, :ip => "33.33.33.32"

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", 1024, "--cpus", 2]

    # Disable DNS proxy.
    # Causes slowness: https://github.com/rubygems/rubygems/issues/513
    #vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    #vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.json = {
        :r => {
            :install_repo => false,
            :install_method => "source",
            :prefix_bin => "/usr/local/bin",
            :config_opts => ["--enable-R-shlib"], #--with-readline=no 
            :libraries => [
                {
                    :name => "snow"
                },
                {
                    :name => "Rserve"
                },
                {
                    :name => "rJava"
                }
            ],
            :rserve_start_on_boot => true
        }
    }

    chef.add_recipe("r::default")
    chef.add_recipe("r::rserve")
  end
end
