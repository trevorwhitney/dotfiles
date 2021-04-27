#!/usr/bin/env zsh

current_dir="$(cd $(dirname "$0") && pwd)"
dot_files_dir="$(cd $current_dir/.. && pwd)"

# shellcheck disable=SC1090
source "$dot_files_dir/lib.sh"

if [[ $(uname) = "Darwin" ]]; then
  brew install alacritty
else
  sudo apt-get install -y alacritty
fi

mkdir -p $HOME/.config/alacritty

create_alacritty_link "$current_dir/alacritty-light.yml"
create_alacritty_link "$current_dir/alacritty-dark.yml"
create_alacritty_link "$current_dir/base.yml"
create_alacritty_link "$current_dir/gruvbox-dark.yml"
create_alacritty_link "$current_dir/gruvbox.yml"
create_alacritty_link "$current_dir/remote-dark.yml"
create_alacritty_link "$current_dir/remote.yml"

if [[ ! -e "$HOME/.config/alacritty/alacritty.yml" ]]; then
  ln -sf "$HOME/.config/alacritty/alacritty-light.yml" "$HOME/.config/alacritty/alacritty.yml"
fi

