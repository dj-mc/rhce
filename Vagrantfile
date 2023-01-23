# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
    vb.name = "cos7"
    # vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
  end

  # $vm_tools = <<-SCRIPT
  #   sudo yum install -y qemu-kvm libvirt virt-manager libvirt-client
  #   sudo yum group install -y "Virtualization Client"
  #   sudo yum group list
  #   sudo systemctl start libvirtd
  #   sudo systemctl enable libvirtd
  # SCRIPT

  # config.vm.provision "shell", inline: $vm_tools
end
