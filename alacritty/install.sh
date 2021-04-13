#!/usr/bin/env zsh

current_dir="$(cd $(dirname "$0") && pwd)"

if [[ $(uname) = "Darwin" ]]; then
  brew install alacritty
else
  sudo apt-get install -y alacritty
fi

create_alacritty_link() {
  file_name="$(basename "$1" | sed "s/^\.//g")"
  if [[ -h "$HOME/.config/alacritty/$file_name" ]] || [[ -e "$HOME/.config/alacritty/$file_name" ]]; then
    rm -rf "$HOME/.config/alacritty/$file_name"
  fi

  ln -sf "$1" "$HOME/.config/alacritty/$file_name"
}

create_alacritty_link "$current_dir/alacritty.yml"
create_alacritty_link "$current_dir/alacritty-dark.yml"
create_alacritty_link "$current_dir/base.yml"
create_alacritty_link "$current_dir/gruvbox-dark.yml"
create_alacritty_link "$current_dir/gruvbox.yml"
create_alacritty_link "$current_dir/remote-dark.yml"
create_alacritty_link "$current_dir/remote.yml"
