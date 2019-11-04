#!/usr/bin/env bash

sudo apt update

current_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
packages=$(cat $current_dir/packages | grep -v '^#')
sudo apt install -y ${packages}