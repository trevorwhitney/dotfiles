#!/bin/bash

current_dir=$(cd $(dirname $0) && pwd)

create_link() {
    if [ -h "$HOME/.$1" ] || [ -e "$HOME/.$1" ]; then
        rm -rf "$HOME/.$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.$1"
}

git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it
$HOME/.bash_it/install.sh

create_link bash_profile
