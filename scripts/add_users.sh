#!/usr/bin/env bash

for user in alice bobby charlie; do
  if id $user &> /dev/null; then
    echo "$user already exists"
  else
    sudo useradd -m $user
    echo pass123 | sudo passwd --stdin $user
    tail -n1 /etc/passwd
  fi
done
