#!/bin/bash

create_link() {
    if [ -e ~/$1 ]; then
        rm -rf ~/$1;
    fi

    ln -s ~/.dotfiles/$1 ~/$1;
}

create_link .ctags
create_link .dircolors
create_link .gitconfig
create_link .tmux.conf
create_link .vimrc

create_vim_link() {
    if [ -e ~/.vim/$1 ]; then
        rm -rf ~/.vim/$1;
    fi

    ln -s ~/.dotfiles/.vim/$1 ~/.vim/$1
}

create_vim_link vimrc.bundles
create_vim_link vimrc.coffeescript.bundles
create_vim_link vimrc.config
create_vim_link vimrc.javascript.bundles
create_vim_link vimrc.localvimrc.config
create_vim_link vimrc.ruby.bundles
create_vim_link vimrc.ruby.config
