#!/usr/bin/env zsh

set -e

current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

# shellcheck disable=SC1090
source "$dot_files_dir/lib.sh"

if [ -e "$HOME/.oh-my-zsh/" ]; then
    pushd "$HOME/.oh-my-zsh"
        git pull --rebase
    popd
else
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

create_link "$current_dir/zshrc"
touch "$HOME/.zprofile"

mkdir -p "$HOME/.oh-my-zsh/cache"
echo "LAST_EPOCH=18722" > "$HOME/.oh-my-zsh/cache/.zsh-update"

create_custom_zsh_link aliases.zsh
create_custom_zsh_link docker-completion.zsh
create_custom_zsh_link docker-compose-completion.zsh
create_custom_zsh_link gh-completion.zsh
create_custom_zsh_link k3d-completion.zsh
create_custom_zsh_link kubectl-completion.zsh
create_custom_zsh_link themes/philips.zsh-theme
create_custom_zsh_link themes/agnoster-gruvbox.zsh-theme
