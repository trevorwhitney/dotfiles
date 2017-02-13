#!/bin/bash

set -ex

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
[ ! -h  $XDG_CONFIG_HOME/nvim ] && ln -s ~/.vim $XDG_CONFIG_HOME/nvim
[ ! -h  $XDG_CONFIG_HOME/nvim/init.vim ] && ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

create_vim_link() {
    [ -h "$HOME/.vim/$1" ] && rm -rf "$HOME/.vim/$1"

    ln -s "$HOME/.dotfiles/.vim/$1" "$HOME/.vim/$1"
}

create_vim_link vimrc.bundles
create_vim_link vimrc.coffeescript.bundles
create_vim_link vimrc.config
create_vim_link vimrc.javascript.bundles
create_vim_link vimrc.haskell.bundles
create_vim_link vimrc.localvimrc.config
create_vim_link vimrc.ruby.bundles
create_vim_link vimrc.ruby.config
create_vim_link vimrc.haskell.bundles
create_vim_link vimrc.haskell.config
create_vim_link vimrc.kotlin.bundles
create_vim_link vimrc.scala.bundles
create_vim_link vimrc.java.bundles
create_vim_link vimrc.java.config

create_vim_link vimrc.neovim.bundles
create_vim_link vimrc.neovim.config

if [ ! -e "$HOME/.vim/bundles" ]; then 
  # git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  mkdir -p ~/tmp
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ~/tmp/dein-installer.sh
  chmod a+x ~/tmp/dein-installer.sh
  ~/tmp/dein-installer.sh ~/.vim/bundles
fi

os=`uname`
if [ $os == 'Darwin' ]; then
  sed -e 's/^colorscheme/"colorscheme/' -i ''  $HOME/.dotfiles/.vim/vimrc.config
elif [ $os == 'Linux' ]; then
  sed -e 's/^colorscheme/"colorscheme/' -i''  $HOME/.dotfiles/.vim/vimrc.config
fi

vim --noplugin +"silent call dein#install()" +qall
which nvim && nvim --noplugin -c "call dein#install()" -c "UpdateRemotePlugins" -c "qall"

if [ $os == 'Darwin' ]; then
  sed -e 's/^"colorscheme/colorscheme/' -i ''  $HOME/.dotfiles/.vim/vimrc.config
elif [ $os == 'Linux' ]; then
  sed -e 's/^"colorscheme/colorscheme/' -i''  $HOME/.dotfiles/.vim/vimrc.config
fi
