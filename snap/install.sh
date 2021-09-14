#!/usr/bin/env zsh
current_dir=$(cd "$(dirname $0)" && pwd)

sudo apt update
sudo apt install -y snapd

for package in $(< $current_dir/packages); do
  sudo snap install --classic $package
done
