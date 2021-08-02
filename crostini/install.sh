#!/usr/bin/env zsh
set -e

current_dir="$(cd $(dirname "$0") && pwd)"
dot_files_dir="$(cd $current_dir/.. && pwd)"

# shellcheck disable=SC1090
source "$dot_files_dir/lib.sh"

mkdir -p "$HOME/.config/alacritty"
create_custom_zsh_link crostini.zsh
create_alacritty_link "$current_dir/alacritty-crostini.yml"

ln -sf "$HOME/.config/alacritty/alacritty-crostini.yml" "$HOME/.config/alacritty/alacritty.yml"
sudo ln -sf "$current_dir/alacritty.desktop" /usr/share/applications/alacritty.desktop

# Move to Debian SID and install Tailscale
sudo ln -sf "$current_dir/sources.list" /etc/apt/sources.list
curl -fsSL https://pkgs.tailscale.com/stable/debian/sid.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/debian/sid.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale

