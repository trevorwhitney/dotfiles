#!/usr/bin/env bash

set -e

current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

# shellcheck disable=SC1090
source "$dot_files_dir/lib.sh"

create_custom_zsh_link() {
    if [ -h "$HOME/.oh-my-zsh/custom/$1" ] || [ -e "$HOME/.oh-my-zsh/custom/$1" ]; then
        rm -rf "$HOME/.oh-my-zsh/custom/$1";
    fi

    ln -s "$current_dir/$1" "$HOME/.oh-my-zsh/custom/$1"
}

if [ -e "$HOME/.oh-my-zsh/" ]; then
    pushd "$HOME/.oh-my-zsh"
        git pull --rebase
    popd
else
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

create_link "$current_dir/zshrc"
touch "$HOME/.zprofile"

create_custom_zsh_link aliases.zsh
create_custom_zsh_link docker-completion.zsh
create_custom_zsh_link docker-compose-completion.zsh
create_custom_zsh_link gulp-completion.zsh
create_custom_zsh_link k3d-completion.zsh
create_custom_zsh_link kubectl-completion.zsh
create_custom_zsh_link themes/philips.zsh-theme
create_custom_zsh_link themes/agnoster.zsh-theme

ln -sf "$current_dir/tmux-mouse-state.sh" /usr/local/bin/tmux-mouse-state
