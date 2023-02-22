#!/usr/bin/env bash

echo "Executing commands via ansible script module..."
ansible localhost -m script -a "/home/vagrant/scripts/hello_world.sh"
