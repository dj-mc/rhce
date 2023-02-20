#!/usr/bin/env bash

sudo timedatectl set-timezone 'America/Chicago'

if [ -f '/usr/bin/dnf' ]; then
  sudo dnf install -y tree
elif [ -f '/usr/bin/apt' ]; then
  sudo apt update
  sudo apt install -y tree
fi
