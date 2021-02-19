#!/usr/bin/env bash

set -euf

current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

source "$dot_files_dir/lib.sh"

create_vim_link() {
  file_name="$(basename "$1" | sed "s/^\.//g")"
  if [[ -h "$HOME/.vim/$file_name" ]] || [[ -e "$HOME/.vim/$file_name" ]]; then
    rm -rf "$HOME/.vim/$file_name"
  fi

  ln -s "$1" "$HOME/.vim/$file_name"
}

create_custom_vim_link() {
    if [ -h "$HOME/.vim/$1" ] || [ -e "$HOME/.vim/$1" ]; then
        rm -rf "$HOME/.vim/$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.vim/$1"
}

mkdir -p $HOME/.vim
mkdir -p $HOME/.vim/colors
create_vim_link "$current_dir/vimrc.bundles"
create_vim_link "$current_dir/vimrc.config"
create_custom_vim_link "colors/gruvbox.vim"
create_custom_vim_link "colors/gruvbox_less_red.vim"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sed -e 's/^colorscheme/"colorscheme/' "$HOME/.vim/vimrc.config" > "$current_dir/vimrc.config.tmp"
mv "$current_dir/vimrc.config.tmp" "$HOME/.vim/vimrc.config"

set +e
vim --noplugin +"silent PlugInstall" +qall
set -e

sed -e 's/^"colorscheme/colorscheme/' "$HOME/.vim/vimrc.config" > "$current_dir/vimrc.config.tmp"
mv "$current_dir/vimrc.config.tmp" "$HOME/.vim/vimrc.config"

# need to create the line again to override the moved file
create_vim_link "$current_dir/vimrc.config"

if [[ -h "$HOME/.vim/style" ]] || [[ -d "$HOME/.vim/style" ]]; then
  rm -rf "$HOME/.vim/style"
fi
ln -s "$current_dir/style" "$HOME/.vim/style"

create_link "$current_dir/vimrc"
create_link "$current_dir/ideavimrc"

function install_astyle() {
    mkdir -p ~/tmp/astyle
    curl -L https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_macos.tar.gz/download -o ~/tmp/astyle/astyle.tar.gz
    pushd ~/tmp/astyle
      tar -xzf astyle.tar.gz
      pushd astyle/build/mac
        make
        sudo cp bin/AStyle /usr/local/bin/astyle
        sudo chmod a+x /usr/local/bin/astyle
      popd
    popd
    rm -rf ~/tmp/astyle
}
if [ ! `which astyle` ]; then install_astyle; fi

sudo pip3 install --upgrade -r "$HOME/.vim/plugged/taskwiki/requirements.txt"

