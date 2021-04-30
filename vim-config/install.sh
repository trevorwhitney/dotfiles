#!/usr/bin/env zsh

set -euf

current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

source "$dot_files_dir/lib.sh"

create_vim_link() {
  file_name="$(basename "$1" | sed "s/^\.//g")"
  if [[ -h "$HOME/.vim/$file_name" ]] || [[ -e "$HOME/.vim/$file_name" ]]; then
    rm -rf "$HOME/.vim/$file_name"
  fi

  ln -sf "$1" "$HOME/.vim/$file_name"
}

create_custom_vim_link() {
    if [ -h "$HOME/.vim/$1" ] || [ -e "$HOME/.vim/$1" ]; then
        rm -rf "$HOME/.vim/$1";
    fi

    echo "creating custom vim link $HOME/.vim/$1"
    ln -sf "$current_dir/$1" "$HOME/.vim/$1"
}

create_link "$current_dir/vimrc"
create_link "$current_dir/ideavimrc"

mkdir -p $HOME/.vim
mkdir -p $HOME/.vim/colors
mkdir -p $HOME/.vim/undodir

create_vim_link "$current_dir/bundles.vim"
create_vim_link "$current_dir/config.vim"

create_custom_vim_link "colors/gruvbox.vim"
create_custom_vim_link "colors/gruvbox_less_red.vim"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

set +e
vim --noplugin +"silent PlugInstall" +qall
set -e

if [[ -h "$HOME/.vim/style" ]] || [[ -d "$HOME/.vim/style" ]]; then
  rm -rf "$HOME/.vim/style"
fi
ln -s "$current_dir/style" "$HOME/.vim/style"

if [[ -e  "$HOME/.vim/plugged/taskwiki/requirements.txt" ]]; then
  sudo pip3 install --upgrade -r "$HOME/.vim/plugged/taskwiki/requirements.txt"
fi

