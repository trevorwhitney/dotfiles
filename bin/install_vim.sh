#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

if [ ! -e "$HOME/.vim" ]; then
  mkdir "$HOME/.vim"
fi

[ ! -h $HOME/.vim/style ] && ln -s $dotfiles_dir/style $HOME/.vim/style

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
[ ! -h  $XDG_CONFIG_HOME/nvim ] && ln -s $HOME/.vim $XDG_CONFIG_HOME/nvim
[ ! -h  $XDG_CONFIG_HOME/nvim/init.vim ] && ln -s $HOME/.vimrc $XDG_CONFIG_HOME/nvim/init.vim

create_vim_link() {
  [ -h "$HOME/.vim/$1" ] && rm -rf "$HOME/.vim/$1"

  ln -s "$dotfiles_dir/.vim/$1" "$HOME/.vim/$1"
}

create_vim_link vimrc.bundles
create_vim_link vimrc.coffeescript.bundles
create_vim_link vimrc.config
create_vim_link vimrc.javascript.bundles
create_vim_link vimrc.javascript.config
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
create_vim_link vimrc.html.bundles
create_vim_link vimrc.purescript.bundles
create_vim_link vimrc.purescript.config
create_vim_link vimrc.elm.bundles
create_vim_link vimrc.elm.config

create_vim_link vimrc.neovim.bundles
create_vim_link vimrc.neovim.config

if [ ! -e "$HOME/.vim/bundles" ]; then
  mkdir -p ~/tmp
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ~/tmp/dein-installer.sh
  chmod a+x ~/tmp/dein-installer.sh
  ~/tmp/dein-installer.sh ~/.vim/bundles
  rm ~/tmp/dein-installer.sh
fi

if $darwin; then
  sed -e 's/^colorscheme/"colorscheme/' -i ''  $dotfiles_dir/.vim/vimrc.config
else
  sed -e 's/^colorscheme/"colorscheme/' -i''  $dotfiles_dir/.vim/vimrc.config
fi

vim --noplugin +"silent call dein#install()" +qall
which nvim && XDG_CONFIG_HOME=$HOME/.config nvim --noplugin -c "call dein#install()" -c "UpdateRemotePlugins" -c "qall"

if $darwin; then
  sed -e 's/^"colorscheme/colorscheme/' -i ''  $dotfiles_dir/.vim/vimrc.config
else
  sed -e 's/^"colorscheme/colorscheme/' -i''  $dotfiles_dir/.vim/vimrc.config
fi

