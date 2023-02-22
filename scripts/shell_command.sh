#!/usr/bin/env bash

# An attacker could use shell to execute malicious code
# The command module is a bit more secure because of this

MYVAR='echo asdf; ls -la /etc/hosts'
echo $MYVAR

ansible rocky -m shell -a "echo $MYVAR"
ansible rocky -m command -a "echo $MYVAR"
