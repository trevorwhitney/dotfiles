#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
BASH_IT=$HOME/.bash_it
source $current_dir/utilities.sh

function load_one() {
  file_type=$1
  file_to_enable=$2
  mkdir -p "$BASH_IT/${file_type}/enabled"

  dest="${BASH_IT}/${file_type}/enabled/${file_to_enable}"
  if [ ! -e "${dest}" ]; then
    ln -sf "../available/${file_to_enable}" "${dest}"
  else
    echo "File ${dest} exists, skipping"
  fi
}

if [ ! -e "$HOME/.bash_it" ]; then
  git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it


  if [ -e "$HOME/.$CONFIG_FILE" ]; then
    rm -f "$HOME/.$CONFIG_FILE"
  fi

  if [ -e "$HOME/.$CONFIG_FILE.bak" ]; then
    rm -f "$HOME/.$CONFIG_FILE.bak"
  fi

  load_one completion bash-it.completion.bash
  load_one completion system.completion.bash
  load_one plugins base.plugin.bash
  load_one plugins alias-completion.plugin.bash
  load_one aliases general.aliases.bash
fi

# Linking files is good for configurations
# we want to track changes to
create_link() {
    if [ -h "$HOME/.$1" ] || [ -e "$HOME/.$1" ]; then
        rm -rf "$HOME/.$1";
    fi

    ln -s "$dotfiles_dir/$1" "$HOME/.$1"
}

create_link ctags
create_link dircolors
create_link vimrc
create_link ideavimrc
create_link gitignore_global
create_link git-completion
create_link git_template

create_link $CONFIG_FILE

[ -h "$HOME/.tmux.conf" ] && rm -rf "$HOME/.tmux.conf"
if $darwin; then
  ln -s "$dotfiles_dir/tmux.darwin.conf" "$HOME/.tmux.conf"
else
  ln -s "$dotfiles_dir/tmux.linux.conf" "$HOME/.tmux.conf"
fi

# Copying files is good for configurations that might
# have local overrides, since we don't want to track
# the local overrirdes in version control
copy_file() {
    if [ -e "$HOME/.$1" ]; then
        rm -rf "$HOME/.$1";
    fi

    cp "$dotfiles_dir/$1" "$HOME/.$1"
}
copy_file gitconfig
