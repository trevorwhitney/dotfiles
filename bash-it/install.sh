#!/bin/bash

current_dir=$(cd $(dirname "$0") && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

source "$dot_files_dir/lib.sh"

create_custom_link() {
    if [[ -h "$HOME/.bash_it/custom/$1" ]] || [[ -e "$HOME/.bash_it/custom/$1" ]]; then
        rm -rf "$HOME/.bash_it/custom/$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.bash_it/custom/$1"
}

create_theme_link() {
    if [[ -h "$HOME/.bash_it/custom/themes/$1" ]] || [[ -e "$HOME/.bash_it/custom/themes/$1" ]]; then
        rm -rf "$HOME/.bash_it/custom/themes/$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.bash_it/custom/themes/$1"
}


if [[ ! -e ~/.bash_it ]]; then
  git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it
  $HOME/.bash_it/install.sh
fi

mkdir -p "$HOME/.bash_it/custom/themes"

if [[ $(uname) =~ 'Darwin' ]]; then
  create_link "$current_dir/bash_profile"
else
  create_link "$current_dir/bashrc"
fi

create_custom_link alias-git.bash
create_theme_link bobby.theme.bash
