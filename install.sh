#!/bin/bash

set -ex

current_dir=$(cd $(dirname 0) && pwd)

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

  $HOME/.bash_it/install.sh
fi

# Linking files is good for configurations
# we want to track changes to
create_link() {
    if [ -e "$HOME/$1" ]; then
        rm -rf "$HOME/$1";
    fi

    ln -s "$HOME/.dotfiles/$1" "$HOME/$1"
}

create_link .ctags
create_link .dircolors
create_link .tmux.conf
create_link .vimrc
create_link .ideavimrc
create_link .bash_profile
create_link .gitignore_global
create_link .git-completion

# Copying files is good for configurations that might
# have local overrides, since we don't want to track
# the local overrirdes in version control
copy_file() {
    if [ -e "$HOME/$1" ]; then
        rm -rf "$HOME/$1";
    fi

    cp "$HOME/.dotfiles/$1" "$HOME/$1"
}

copy_file .gitconfig

$current_dir/install_vim.sh
