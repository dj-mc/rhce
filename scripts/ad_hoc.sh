#!/usr/bin/env bash

cd ~ || exit

# -b: become, -m: module, -a: args k=v
ansible -b all -m package -a 'name=tree state=present'

# Force overwrite symbolic link
# path -> src
ansible -b all -m file -a \
'path=/etc/localtime state=link src=/usr/share/zoneinfo/America/Chicago force=true'
