#!/bin/bash

create_link() {
    if [ -e ~/$1 ]; then
        rm -rf ~/$1;
    fi

    cp -r ~/.dotfiles/$1 ~/$1;
}

create_link .ctags
create_link .dircolors
create_link .gitconfig
create_link .tmux.conf
create_link .vimrc

cp -r ~/.dotfiles/.vim/* ~/.vim
