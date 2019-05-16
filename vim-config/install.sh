#!/usr/bin/env bash

set -euf

current_dir=$(cd $(dirname $0) && pwd)

create_link() {
    if [[ -h "$HOME/.$1" ]] || [[ -e "$HOME/.$1" ]]; then
        rm -rf "$HOME/.$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.$1"
}

create_vim_link() {
  if [[ -h "$HOME/.vim/$1" ]] || [[ -e "$HOME/.vim/$1" ]]; then
    rm -rf "$HOME/.vim/$1"
  fi

  ln -s "$current_dir/$1" "$HOME/.vim/$1"
}

mkdir -p $HOME/.vim
create_vim_link vimrc.bundles
create_vim_link vimrc.config
create_vim_link style
create_link vimrc

function install_astyle() {
    mkdir -p ~/tmp/astyle
    curl -L https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_macos.tar.gz/download -o ~/tmp/astyle/astyle.tar.gz
    pushd ~/tmp/astyle
      tar -xzf astyle.tar.gz
      pushd astyle/build/mac
        make
        cp bin/AStyle /usr/local/bin/astyle
        chmod a+x /usr/local/bin/astyle
      popd
    popd
    rm -rf ~/tmp/astyle
}
if [ ! `which astyle` ]; then install_astyle; fi

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sed -e 's/^colorscheme/"colorscheme/' $HOME/.vim/vimrc.config > $(pwd)/vimrc.config.tmp
mv $(pwd)/vimrc.config.tmp $HOME/.vim/vimrc.config

set +e
vim --noplugin +"silent PlugInstall" +qall
set -e

sed -e 's/^"colorscheme/colorscheme/' $HOME/.vim/vimrc.config > $(pwd)/vimrc.config.tmp
mv $(pwd)/vimrc.config.tmp $HOME/.vim/vimrc.config
