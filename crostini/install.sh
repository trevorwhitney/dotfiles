#!/usr/bin/env zsh

current_dir="$(cd $(dirname "$0") && pwd)"
dot_files_dir="$(cd $current_dir/.. && pwd)"

# shellcheck disable=SC1090
source "$dot_files_dir/lib.sh"

mkdir -p "$HOME/.config/alacritty"
create_custom_zsh_link crostini.zsh
create_alacritty_link "$current_dir/alacritty-crostini.yml"

ln -sf "$HOME/.config/alacritty/alacritty-crostini.yml" "$HOME/.config/alacritty/alacritty.yml"
sudo ln -sf "$current_dir/alacritty.desktop" /usr/share/applications/alacritty.desktop
