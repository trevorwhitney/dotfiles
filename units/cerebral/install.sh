#!/usr/bin/env zsh
current_dir=$(cd "$(dirname $0)" && pwd)

sudo apt-get update
sudo apt-get install -y $(< $current_dir/packages)
