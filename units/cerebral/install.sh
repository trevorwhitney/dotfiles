#!/usr/bin/env zsh
current_dir=$(cd "$(dirname $0)" && pwd)

# Kdenlive and OBS Studio PPAs
sudo add-apt-repository -y ppa:kdenlive/kdenlive-stable
sudo apt-add-repository -y ppa:obsproject/obs-studio
sudo apt-add-repository -y ppa:system76-dev/stable

sudo cp "${current_dir}/system76-apt-preferences" /etc/apt/preferences.d/system76-apt-preferences

sudo apt-get update
sudo apt-get install -y $(< $current_dir/packages)

# Install AMD drivers (TODO: will need to paramaterize version)
tmp=$(mktemp -d)
pusd $tmp > /dev/null || exit 1
  curl -LO https://repo.radeon.com/amdgpu-install/22.40/ubuntu/jammy/amdgpu-install_5.4.50401-1_all.deb
  sudo dpkg -i amdgpu-install_5.4.50401-1_all.deb
popd > /dev/null || exit 1

rm -rf $tmp

sudo apt update
amdgpu-install --usecase=workstation -y --vulkan=pro --opencl=rocr,legacy
