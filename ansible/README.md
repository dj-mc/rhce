# ansible

todo

- ansible configuration
- ansible facts and variables
- ansible is agnostic
- ansible vs. ansible-playbook
- yml and jinja
- host inventory and node groups
- documentation
  - ansible-doc -l
  - ansible-doc ping
- playbooks
  - gather_facts: true
  - /etc/ansible/ansible.cfg
  - /etc/ansible/hosts

---

## RHEL-Only Configuration

Install Ansible as a control node on RHEL.

```bash
# Enable the repo for Ansible on RHEL
sudo subscription-manager repos --list | grep ansible
sudo subscription-manager repos --enable ansible-<current version>

sudo yum install -y dnf-plugins-core
sudo yum config-manager --disable epel epel-modular
sudo yum repolist
sudo yum install -y ansible
```

### Non-RHEL Configuration (CentOS/Rocky)

Only one system should have Ansible installed.  
I have it installed on the `rocky1` VM created via Vagrant. However, it can also
be installed on the same bare-metal machine that's running Vagrant.  
I wrote a guide on setting up Vagrant + Ansible on Ubuntu [here](https://github.com/dj-mc/ansi).

Install Ansible as a control node on CentOS or Rocky.

```bash
sudo yum install -y epel-release
sudo yum install -y ansible
```

Confirm `ansible` is available to your system.  
`ansible-playbook` is a symbolic link to Ansible.

```bash
which ansible
file $(which ansible)
file $(which ansible-playbook)
ansible --version
```

## Ad Hoc Commands

`ansible [pattern] -m [module] -a "[module options]"`

`key=value` or JSON can be used as module options.  
Ad hoc commands are good for one-off jobs that don't require creating a new playbook.

```bash
ansible localhost -m ping
# Explicitly use local connection
ansible_connection=local ansible localhost -m ping

# -a, --args: Arguments for the module package in k=v format
ansible_connection=local ansible localhost -m package -a 'name=zsh'
# -b, --become: Become root user and install the package zsh
ansible_connection=local ansible localhost -b -m package -a 'name=zsh'

# Find an Ansible module's Python file
find /usr/lib/python3.9/site-packages/ansible -name ping.py
# If using pipx or a different version of Python
find ~/.local/pipx/venvs/ansible/lib/python3.10/site-packages/ansible -name ping.py
# Ansible must target a node and reference a Python module
```

```bash
ansible debug
man -k ansible debug
```

---

## Reusable Playbooks

`vim my-play.yml`

```yaml
- name: My Play
  hosts: localhost
  connection: local
  tasks:
    - name: Ping Me
      ping:
```

`ansible-playbook my-play.yml`

---

## Configuring Ansible

The default Ansible configuration provides an example setup: `/etc/ansible/ansible.cfg`

todo

- config hierarchy
- custom configuration
- display config values
- config read-only values

```bash
hostnamectl
file $(which ansible)
whereis ansible
whereis python

ansible localhost -m ping
ansible_connection=local ansible localhost -m ping
ansible_connection=local ansible localhost -m package -a 'name=zsh'
ansible_connection=local ansible localhost -b -m package -a 'name=zsh'

ls /usr/lib/python3.9/site-packages/ansible/modules/
find /usr/lib/python3.9/site-packages/ansible -name ping.py
```

---

## Finding Ansible Documentation

```bash
ansible-doc -l
ansible-doc -l | wc -l
ansible-doc ping
ansible-doc package
```

```bash
/usr/bin/ansible --version
ansible_connection=local ansible localhost -b -m package -a 'name=zsh state=absent'
ansible_connection=local ansible localhost -m setup
ansible_connection=local ansible localhost -m setup -a "filter=ansible_os_family"
ansible-playbook ansible/my-play.yml
ansible localhost -m setup
ansible localhost -m setup -a "filter=ansible_os_family"
ansible localhost -m setup -a "filter=ansible_distribution"
ansible-playbook ansible/my-play.yml
```

---

## Configuration Hierarchy

The hierarchy, based on topmost priority.  
The topmost rank's configuration, if it exists, will override all below it.

- `ANSIBLE_CONFIG`
- `$CWD/ansible.cfg`
- `$HOME/.ansible.cfg`
- `/etc/ansible/ansible.cfg`

```bash
# Provided by default
cat /etc/ansible/ansible.cfg

# Generate a config in a particular directory
ansible-config init --disabled > ~/ansible/ansible.cfg

man less
# The default inventory
less /etc/ansible/hosts
# The default configuration
less /etc/ansible/ansible.cfg
less /etc/ansible/ansible.cfg | grep cfg
```

```bash
# Config from ~
touch ~/.ansible.cfg
ansible --version

# Set config from environment variable
ANSIBLE_CONFIG=/etc/ansible/ansible.cfg ansible --version
ansible --version | grep 'config file'
```

```bash
ansible-config view
ansible-config list
ansible-config dump
ansible-config dump --only-changed
```

### Configure the ~/.ansible.cfg File

```bash
vim ~/.ansible.cfg
```

Input the following:

```ini
[defaults]
inventory = ansible/inventory
remote_user = penguin

[privilege_escalation]
become = True
```

```bash
ansible-config view
ansible-config list | grep true
ansible-config dump --only-changed
ansible localhost -m ping

# Privilege esclation with become
# -b in an ad-hoc command is no longer necessary
ansible localhost -m package -a 'name=zsh'
```

---

## Enforcing a Configuration

```bash
vim ~/.bashrc
# Append the following:
# export ANSIBLE_CONFIG=/etc/ansible/ansible.cfg
source ~/.bashrc

ansible --version
unset ANSIBLE_CONFIG
ansible --version

vim ~/.bashrc
# Alter the previous line as:
# declare -xr ANSIBLE_CONFIG=/etc/ansible/ansible.cfg
# -x: mark names for export
# -r: mark names for readonly
source ~/.bashrc

# Now the config location cannot be altered outside of ~/.bashrc
unset ANSIBLE_CONFIG
ANSIBLE_CONFIG=.ansible.cfg
ansible --version
```

---

## Build an Inventory

Available as `ini`, `yaml`, and `json`

Default inventory: `/etc/ansible/hosts`

A group named `[webservers]` and its collection of hosts:

```ini
[webservers]
abc.example.org
another.example.org
192.168.1.100
192.168.1.110
```

Use the implicit localhost entry with any inventory:

```bash
ansible-inventory --host localhost
```

An `ansible_connection` of `local` means we won't need to SSH into another
machine to run ad hoc commands.

Connect to `localhost` and run the `-m` (module) `ping`.

```bash
ansible localhost -m ping
```

Node groups are used to access categories of similar nodes based on their
configuration or purpose. The default groups are `all` and `ungrouped`.

`group_vars` and `host_vars`

implicit localhost  
ansible_connection: local

- Inventory types
- Inventory variables
- Inventory groups
- Listing the inventory
- Dynamic inventories

To target nodes:

- Inventory file
- Default inventory file documents settings
- INI, JSON, YAML
- Variables, `group_vars`, `host_vars`
- Awk and grep to create dynamic inventories

Manage nodes with ad hoc commands:

- SSH key-based auth
- Creating ansible users
- Working w/ mixed environments
- Passing variables w/ CLI
- Ansible ad hoc commands
- Ansible documentation

```bash
echo "ansible_connection: local" > ~/ansible/host_vars/192.168.33.14
echo "ansible_connection: local" > ~/ansible/host_vars/192.168.33.15
ansible-inventory --host 192.168.33.14
ansible-inventory --host 192.168.33.15
```

Find information on inventories:

```bash
ansible 192.168.33.14 -m ping
ansible 192.168.33.15 -m ping

# Grouped inventory
cat ansible/inventory

# List inventory groups
ansible --list all
ansible --list ungrouped
ansible --list rocky
ansible --list redhat

# Output inventory as json
ansible-inventory --list
# Output inventory as yaml
ansible-inventory --list -y
```

Dynamic inventory:

```bash
man nmap
sudo yum install nmap
sudo nmap -Pn -p22 -n 192.168.33.0/24 --open
sudo nmap -Pn -p22 -n 192.168.33.0/24 --open -oG -
sudo nmap -Pn -p22 -n 192.168.33.0/24 --open -oG - | awk '/22\/open/{ print $2 }'
```

---

## Vagrant, SSH, and Ansible

- Copy vagrant keys to control node
- Connect to systems to test/collect public keys of nodes
- Create a user (named `penguin`) with sudo rights
- Generate keys for vagrant to login as `penguin`
- Login and distribute keys to remote nodes
- Adjust `.ansible.cfg` to use a private key automatically

---

## SSH Key-Based Authentication

### Vagrant SSH Keys

- Authenticate via keys with SSH
- Copy these keys from managed nodes to the control node
- Keys are regenerated after each reboot
- Password auth is disabled (on Vagrant VMs)

### Vagrant SCP

```bash
vagrant ssh-config
# Note the IdentityFiles of the guest VMs

vagrant install vagrant-scp
# Copy and paste the private_key as an argument to scp
# host:guest.key
vagrant scp .vagrant/machines/rocky2/virtualbox/private_key rocky1:rocky2.key
```

---

## SSH and Ad Hoc Ansible Commands

```bash
ansible 192.168.33.15 --private-key rocky2.key -u vagrant -m ping
ansible rocky --private-key rocky2.key -u vagrant -m ping
```

Manage users with ad hoc commands:

```bash
# Add a user named penguin
ansible 192.168.33.15 --private-key rocky2.key -u vagrant -m user -a "name=penguin state=present"
# Remove a user named penguin
ansible 192.168.33.15 --private-key rocky2.key -u vagrant -m user -a "name=penguin state=absent"

# Configure a user's sudoer privileges
echo "penguin ALL=(root) NOPASSWD: ALL" > penguin
# Confirm the file is parsed OK
visudo -cf penguin

# Copy the user file to the /etc/sudoers.d/ directory
ansible 192.168.33.15 --private-key rocky2.key -u vagrant -m copy -a "src=penguin dest=/etc/sudoers.d/"

# Generate an ssh key with an empty password
ssh-keygen

# Authorize the ssh key with the authorized_key module
# Lookup the id_rsa.pub file with jinja
ansible 192.168.33.15 --private-key rocky2.key -u vagrant -m authorized_key -a "user=penguin state=present key='{{ lookup('file', '/home/vagrant/.ssh/id_rsa.pub') }}'"
```

```bash
vim ~/.ansible.cfg
```

Append the following:

```ini
[defaults]
inventory = ansible/inventory
remote_user = penguin
private_key_file = ~/.ssh/id_rsa

[privilege_escalation]
become = True
```

```bash
ansible all -m ping
```

SSH into a managed node from the control node:

```bash
ssh -i rocky2.key 192.168.33.15
```

Learn more about the `-m user` module:

`ansible-doc user`

```bash
# Don't forget
ansible-doc --help
ansible-doc --list
```

---

## Agnostic Installation of Packages

The tree package usually has the same name across systems.

`ansible all -m package -a "name=tree state=present`

But some packages have different names:

```bash
# Differentiate packages via groups
# Access the variable `vim_editor` via group_vars
echo "vim_editor: vim-enhanced" >> ansible/group_vars/redhat
echo "vim_editor: vim" >> ansible/group_vars/ubuntu

ansible-inventory --host 192.168.33.14
ansible-inventory --host 192.168.33.15

ansible all -m package -a "name={{ vim_editor }} state=absent"
ansible all -m package -a "name={{ vim_editor }} state=present"
```

---

## More on Playbooks

- Playbooks as yaml
- Linting playbooks' yaml
  - ansible-lint
- Playbooks vs scripts
- Common playbook solutions

- Prevent injection attacks
- Import tasks and playbooks
- Files, packages, services

Lint the playbook yaml files with:

```bash
# Install with pip
pip3 install ansible-lint --user
# Install via package manager
apt search ansible-lint
dnf search ansible-lint

ansible-lint -v ansible/my-play.yml
```

```bash
# Check syntax
ansible-playbook ansible/my-play.yml --syntax-check
# No-operations check with verbose
ansible-playbook -C -v ansible/my-play.yml
ansible-playbook -C -v ansible/playbook-all.yml
```

---

## Finding Ansible Modules

```bash
find /usr/lib -name 'debug.py'
# /usr/lib/python3.9/site-packages/ansible/modules/debug.py
find /usr/lib -name 'package.py'
# /usr/lib/python3.9/site-packages/ansible/modules/package.py
```

---

## Scripting with Ansible

- Idempotent scripts
- Target different operating systems
- Ansible inside scripts, scripts inside Ansible
- Use Ansible to provision Vagrant machines

Other commands available:

Use these when an Ansible module is not available.

- shell
  - opens /bin/sh
  - access variables and stream ops
  - considered less secure
- command
  - native linux commands
  - no creation of parent shell needed
  - no access to variables or stream ops
  - command is preferred over shell
- raw
  - native command execution with no Python requirement
  - `ansible 192.168.33.15 --private-key rocky2.key -u penguin -m raw -a "yum install -y python3"`
- script
  - run a script from the control node across other nodes
- win_command
  - `ansible-galaxy collection install ansible.windows`
- creates
  - meta-parameter to control command execution

---

## The Big Three
