#!/bin/bash

current_dir=$(cd $(dirname $0) && pwd)

create_link() {
    if [[ -h "$HOME/.$1" ]] || [[ -e "$HOME/.$1" ]]; then
        rm -rf "$HOME/.$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.$1"
}

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

mkdir -p $HOME/.bash_it/custom/themes

if [[ $(uname) =~ 'Darwin' ]]; then
  create_link bash_profile
else
  create_link bashrc
fi

create_link bash_aliases
create_custom_link alias-git.bash
create_theme_link bobby.theme.bash
