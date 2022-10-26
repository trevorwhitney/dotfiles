#!/usr/bin/env zsh
current_dir=$(cd "$(dirname $0)" && pwd)

if [[ ! `command -v flatpak` ]]; then
  if [[ `command apt` ]]; then
    sudo apt update -y
    sudo apt install -y flatpak
  else;
    echo "flatpak command not found"
    exit 1
  fi
fi

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
for package in $(< $current_dir/packages); do
  flatpak install --app -y $package
done
