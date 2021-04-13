#!/usr/bin/env zsh

set -euf
current_dir=$(cd "$(dirname $0)" && pwd)

npm install -g gulp-cli

create_custom_zsh_link() {
    if [ -h "$HOME/.oh-my-zsh/custom/$1" ] || [ -e "$HOME/.oh-my-zsh/custom/$1" ]; then
        rm -rf "$HOME/.oh-my-zsh/custom/$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.oh-my-zsh/custom/$1"
}

create_custom_zsh_link gulp-completion.zsh