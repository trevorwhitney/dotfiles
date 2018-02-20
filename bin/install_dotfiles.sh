#!/bin/bash

set -ex

function find_current_dir() {
  pushd $(dirname $0) > /dev/null
    current_dir=$(pwd)
  popd > /dev/null
  echo $current_dir
}
current_dir=$(find_current_dir $@)

source $current_dir/utilities.sh

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
create_link gitignore_global
create_link git_template

[ ! -h $HOME/.vim/style ] && ln -s $dotfiles_dir/style $HOME/.vim/style

create_link $CONFIG_FILE

mkdir -p $HOME/bash_completion.d
create_completion_link() {
    if [ -h "$HOME/bash_completion.d/$1" ] || [ -e "$HOME/bash_completion.d/$1" ]; then
        rm -rf "$HOME/bash_completion.d/$1";
    fi

    ln -s "$dotfiles_dir/bash_completion/$1" "$HOME/bash_completion.d/$1"
}

create_completion_link git-completion
create_completion_link gradle-completion
create_completion_link gulp-completion

mkdir -p $HOME/aliases.d
create_alias_link() {
    if [ -h "$HOME/aliases.d/$1" ] || [ -e "$HOME/aliases.d/$1" ]; then
        rm -rf "$HOME/aliases.d/$1";
    fi

    ln -s "$dotfiles_dir/aliases/$1" "$HOME/aliases.d/$1"
}

create_alias_link default
create_alias_link gradle
create_alias_link git
create_alias_link cf
create_alias_link pivotal

mkdir -p $HOME/.themes
create_themes_link() {
    theme_file="${1}.theme.bash"
    if [ -h "$HOME/.themes/${theme_file}" ] || [ -e "$HOME/.themes/${theme_file}" ]; then
        rm -rf "$HOME/.themes/${theme_file}";
    fi

    ln -s "$dotfiles_dir/themes/${theme_file}" "$HOME/.themes/${theme_file}"
}

create_themes_link base
create_themes_link colors
create_themes_link bobby

[ -h "$HOME/.tmux.conf" ] && rm -rf "$HOME/.tmux.conf"
if $darwin; then
  ln -s "$dotfiles_dir/tmux.darwin.conf" "$HOME/.tmux.conf"
else
  ln -s "$dotfiles_dir/tmux.linux.conf" "$HOME/.tmux.conf"
fi

# Copying files is good for configurations that might
# have local overrides, since we don't want to track
# the local overrides in version control
copy_file() {
    if [ -e "$HOME/.$1" ]; then
        rm -rf "$HOME/.$1";
    fi

    cp "$dotfiles_dir/$1" "$HOME/.$1"
}
copy_file gitconfig
