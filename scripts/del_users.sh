#!/usr/bin/env bash

for user in alice bobby charlie; do
  if id $user &> /dev/null; then
    sudo userdel -r $user
    echo "Deleted $user from system"
  else
    echo "$user does not exist"
  fi
done

tail -n3 /etc/passwd
