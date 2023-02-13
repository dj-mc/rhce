# ansible

todo

```log
[WARNING]: Unable to parse /home/vagrant/inventory as an inventory source
[WARNING]: No inventory was parsed, only implicit localhost is available
```

- ansible vs. ansible-playbook
- ansible facts and variables
- ansible is agnostic
- yml and jinja
- ansible configuration
- host inventory and node groups
- ad hoc
  - -b to elevate
- documentation
  - ansible-doc -l
  - ansible-doc ping
- playbooks
  - gather_facts: true
  - /etc/ansible/ansible.cfg
  - /etc/ansible/hosts

---

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

```bash
vim ~/.ansible.cfg
```

```ini
[defaults]
inventory = inventory
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

## The Environment

- Copy vagrant keys to control node
- Connect to systems to test/collect public keys of nodes
- Create penguin user with sudo rights
- Generate keys for vagrant to login as penguin
- Login and distribute keys to remote nodes
- Adjust .ansible.cfg to use a private key automatically

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
