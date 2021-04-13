#!/usr/bin/env zsh
current_dir=$(cd "$(dirname $0)" && pwd)

sudo apt-get update

packages=$(cat $current_dir/packages | grep -v '^#')
sudo apt-get install -y ${packages}
