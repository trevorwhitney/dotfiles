#!/usr/bin/env bash
current_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

sudo apt-get update

packages=$(cat $current_dir/packages | grep -v '^#')
sudo apt-get install -y ${packages}
