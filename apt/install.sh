#!/usr/bin/env bash
current_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

release = $(lib_release -is)
if [ "$release" == "Ubuntu" ] || [ "$release" == "Pop"]; then
  sudo add-apt-repository -y ppa:neovim-ppa/stable
fi

sudo apt-get update

packages=$(cat $current_dir/packages | grep -v '^#')
sudo apt-get install -y ${packages}
