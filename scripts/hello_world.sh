#!/usr/bin/env bash

for each in hi salut ciao; do
  echo $each
done

i=10
while [ $i -gt 0 ]; do
  echo $i
  let i-=1
done
