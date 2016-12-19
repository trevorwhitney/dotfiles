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

if [ ! -e "$HOME/.vim" ]; then
  mkdir "$HOME/.vim"
fi

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
create_vim_link vimrc.haskell.bundles
create_vim_link vimrc.localvimrc.config
create_vim_link vimrc.ruby.bundles
create_vim_link vimrc.ruby.config
create_vim_link vimrc.haskell.bundles
create_vim_link vimrc.haskell.config
create_vim_link vimrc.kotlin.bundles
create_vim_link vimrc.scala.bundles

if [ ! -e "$HOME/.vim/bundle" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

os=`uname`
if [ $os == 'Darwin' ]; then
  sed -e 's/^colorscheme/"colorscheme/' -i ''  $HOME/.vim/vimrc.config
elif [ $os == 'Linux' ]; then
  sed -e 's/^colorscheme/"colorscheme/' -i''  $HOME/.vim/vimrc.config
fi

vim --noplugin +"silent PluginInstall" +"silent VimProcInstall" +qall

if [ $os == 'Darwin' ]; then
  sed -e 's/^"colorscheme/colorscheme/' -i ''  $HOME/.vim/vimrc.config
elif [ $os == 'Linux' ]; then
  sed -e 's/^"colorscheme/colorscheme/' -i''  $HOME/.vim/vimrc.config
fi
