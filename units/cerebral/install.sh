#!/usr/bin/env zsh
current_dir=$(cd "$(dirname $0)" && pwd)

# Kdenlive and OBS Studio PPAs
sudo add-apt-repository ppa:kdenlive/kdenlive-stable
sudo apt-add-repository ppa:obsproject/obs-studio

sudo apt-get update
sudo apt-get install -y $(< $current_dir/packages)
