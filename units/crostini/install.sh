#!/usr/bin/env zsh
set -e

current_dir="$(cd $(dirname "$0") && pwd)"
dot_files_dir="$(cd $current_dir/../.. && pwd)"

# shellcheck disable=SC1090
source "$dot_files_dir/lib.sh"

# Move to Debian SID
sudo ln -sf "$current_dir/sources.list" /etc/apt/sources.list
sudo apt update && sudo apt install -y gnome-keyring seahorse
