#!/bin/bash

set -ex

dir=$(cd $(dirname $0); pwd)

create_link() {
    if [ -h "$HOME/.$1" ] || [ -e "$HOME/.$1" ]; then
        rm -rf "$HOME/.$1";
    fi

    ln -s "$dir/$1" "$HOME/.$1"
}

create_link git-authors
