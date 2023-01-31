# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky8"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
    vb.name = "Rocky 8"
    # vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
  end

  # $tools = <<-SCRIPT
  #
  # SCRIPT

  # config.vm.provision "shell", inline: $tools
end
