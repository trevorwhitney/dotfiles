#!/usr/bin/env zsh
set -e

current_dir="$(cd $(dirname "$0") && pwd)"
dot_files_dir="$(cd $current_dir/../.. && pwd)"

# shellcheck disable=SC1090
source "$dot_files_dir/lib.sh"

# Move to Debian SID
sudo ln -sf "$current_dir/sources.list" /etc/apt/sources.list
curl -fsSL https://pkgs.tailscale.com/stable/debian/sid.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/debian/sid.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update

# firefox
sudo apt update && sudo apt install -y firefox
mkdir -p $HOME/.local/share/applications/
sudo ln -sf "$current_dir/firefox.desktop" /usr/share/applications/firefox.desktop
