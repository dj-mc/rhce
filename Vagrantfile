# -*- mode: ruby -*-
# vi: set ft=ruby :

$preferences = <<-SCRIPT
BASHRC_FILE='/home/vagrant/.bashrc'
HIST_CTRL='HISTCONTROL=ignoreboth'
HIST_EXPORT='export PROMPT_COMMAND="history -a; history -c; history -r"'
HIST_SHOPT='shopt -s histappend'

# -qF: --quiet, --fixed-strings
grep -qF -- "$HIST_CTRL" "$BASHRC_FILE" || echo "\n# History\n$HIST_CTRL" >> "$BASHRC_FILE"
grep -qF -- "$HIST_EXPORT" "$BASHRC_FILE" || echo "$HIST_EXPORT" >> "$BASHRC_FILE"
grep -qF -- "$HIST_SHOPT" "$BASHRC_FILE" || echo "$HIST_SHOPT" >> "$BASHRC_FILE"

INPUTRC_FILE='/home/vagrant/.inputrc'
BRACKETED='set enable-bracketed-paste'

if [ ! -f "$INPUTRC_FILE" ]; then
  touch $INPUTRC_FILE
fi

grep -qF -- "$BRACKETED" "$INPUTRC_FILE" || echo "$BRACKETED" >> "$INPUTRC_FILE"
SCRIPT

$install_control_node = <<-SCRIPT
if ! [ -x "$(command -v ansible)" ]; then
  sudo yum install -y epel-release
  sudo yum install -y ansible
fi
if ! [ -f "/home/vagrant/.ansible.cfg" ]; then
  echo "No home configuration found for Ansible"
  touch .ansible.cfg
fi
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define "rocky1" do |rocky|
    rocky.vm.box = "generic/rocky8"
    rocky.vm.network "private_network", ip: "192.168.33.14"
    rocky.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "512"
      vb.name = "rhce-box1"
    end

    # Let this VM have access to this repo's bash scripts
    rocky.vm.synced_folder "scripts/", "/home/vagrant/scripts",
      owner: "vagrant", group: "vagrant", create: true
    # Let this VM have access to this repo's ansible playbooks
    rocky.vm.synced_folder "ansible/", "/home/vagrant/ansible",
      owner: "vagrant", group: "vagrant", create: true

    rocky.vm.provision "shell", inline: $preferences
    rocky.vm.provision "shell", inline: $install_control_node
  end

  config.vm.define "rocky2" do |rocky|
    rocky.vm.box = "generic/rocky8"
    rocky.vm.network "private_network", ip: "192.168.33.15"
    rocky.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "512"
      vb.name = "rhce-box2"
    end
    rocky.vm.synced_folder "scripts/", "/home/vagrant/scripts",
      owner: "vagrant", group: "vagrant", create: true
    rocky.vm.provision "shell", inline: $preferences
  end
end
