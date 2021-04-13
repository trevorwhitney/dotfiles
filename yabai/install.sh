#!/usr/bin/env zsh
current_dir=$(cd $(dirname "$0") && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

echo "installing yabai and skhd"
# tiling window manager, pre-req: https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
brew install koekeishiya/formulae/yabai # tiling window manager, pre-req: https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
brew install koekeishiya/formulae/skhd #hotkey deamon for use with yabai

brew services stop yabai
brew upgrade yabai
sudo yabai --uninstall-sa
sudo yabai --install-sa
brew services start yabai
brew services restart skhd

echo "Linking yabai and skhd configs"
source "$dot_files_dir/lib.sh"
create_link "$current_dir/yabairc"
create_link "$current_dir/skhdrc"
