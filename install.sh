#!/bin/bash

if [ ! -e "$HOME/.bash_it" ]; then
  git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it

  case $OSTYPE in
    darwin*)
      CONFIG_FILE=.bash_profile
      ;;
    *)
      CONFIG_FILE=.bashrc
      ;;
  esac

  if [ -e "$HOME/$CONFIG_FILE" ]; then
    rm -f "$HOME/$CONFIG_FILE"
  fi

  if [ -e "$HOME/$CONFIG_FILE.bak" ]; then
    rm -f "$HOME/$CONFIG_FILE.bak"
  fi

  ~/.bash_it/install.sh
fi

create_link() {
    if [ -e "$HOME/$1" ]; then
        rm -rf "$HOME/$1";
    fi

    ln -s "$HOME/.dotfiles/$1" "$HOME/$1"
}

create_link .ctags
create_link .dircolors
create_link .gitconfig
create_link .tmux.conf
create_link .vimrc
create_link .ideavimrc
create_link .bash_profile

create_vim_link() {
    if [ -e "$HOME/.vim/$1" ]; then
        rm -rf "$HOME/.vim/$1"
    fi

    ln -s "$HOME/.dotfiles/.vim/$1" "$HOME/.vim/$1"
}

create_vim_link vimrc.bundles
create_vim_link vimrc.coffeescript.bundles
create_vim_link vimrc.config
create_vim_link vimrc.javascript.bundles
create_vim_link vimrc.localvimrc.config
create_vim_link vimrc.ruby.bundles
create_vim_link vimrc.ruby.config

if [ ! -e "$HOME/.vim/bundle" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall
fi
