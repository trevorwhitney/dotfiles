#!/usr/bin/env bash

set -e

current_dir=$(cd $(dirname $0) && pwd)

create_link() {
    if [ -h "$HOME/.$1" ] || [ -e "$HOME/.$1" ]; then
        rm -rf "$HOME/.$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.$1"
}

create_custom_zsh_link() {
    if [ -h "$HOME/.oh-my-zsh/custom/$1" ] || [ -e "$HOME/.oh-my-zsh/custom/$1" ]; then
        rm -rf "$HOME/.oh-my-zsh/custom/$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.oh-my-zsh/custom/$1"
}

if [ -e $HOME/.oh-my-zsh/ ]; then
    pushd $HOME/.oh-my-zsh
        git pull --rebase
    popd
else
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

create_link zshrc
touch $HOME/.zprofile

create_custom_zsh_link aliases.zsh
create_custom_zsh_link gulp-completion.zsh
