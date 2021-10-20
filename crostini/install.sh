#!/usr/bin/env zsh
set -e

current_dir="$(cd $(dirname "$0") && pwd)"
dot_files_dir="$(cd $current_dir/.. && pwd)"

# shellcheck disable=SC1090
source "$dot_files_dir/lib.sh"

# alacritty
mkdir -p "$HOME/.config/alacritty"
create_custom_zsh_link crostini.zsh
create_alacritty_link "$current_dir/alacritty-crostini.yml"

ln -sf "$HOME/.config/alacritty/alacritty-crostini.yml" "$HOME/.config/alacritty/alacritty.yml"
sudo ln -sf "$current_dir/alacritty.desktop" /usr/share/applications/alacritty.desktop
mkdir -p "$HOME/.local/share/icons"
sudo ln -sf "$current_dir/alacritty.png" "$HOME/.local/share/icons/alacritty.png"
sudo ln -sf "$current_dir/alacritty.svg" "$HOME/.local/share/icons/alacritty.svg"

# Move to Debian SID and install Tailscale
sudo ln -sf "$current_dir/sources.list" /etc/apt/sources.list
curl -fsSL https://pkgs.tailscale.com/stable/debian/sid.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/debian/sid.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale

# firefox
sudo apt update && sudo apt install -y firefox
mkdir -p $HOME/.local/share/applications/
sudo ln -sf "$current_dir/firefox.desktop" /usr/share/applications/firefox.desktop
