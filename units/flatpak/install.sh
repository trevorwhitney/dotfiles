#!/usr/bin/env zsh
current_dir=$(cd "$(dirname $0)" && pwd)

if [[ ! `command -v flatpak` ]]; then
  sudo apt update
  sudo apt install -y flatpak
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

for package in $(< $current_dir/packages); do
  flatpak install --app -y $package
done
