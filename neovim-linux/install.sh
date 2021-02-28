#!/usr/bin/env bash
set -e

current_dir=$(cd "$(dirname "$0")" && pwd)

create_vim_link() {
  file_name="$(basename "$1" | sed "s/^\.//g")"
  if [[ -h "$HOME/.vim/$file_name" ]] || [[ -e "$HOME/.vim/$file_name" ]]; then
    rm -rf "$HOME/.vim/$file_name"
  fi

  ln -sf "$1" "$HOME/.vim/$file_name"
}

create_nvim_link() {
  file_name="$(basename "$1" | sed "s/^\.//g")"
  if [[ -h "$HOME/.config/nvim/$file_name" ]] || [[ -e "$HOME/.config/nvim/$file_name" ]]; then
    rm -rf "$HOME/.config/nvim/$file_name"
  fi

  ln -sf "$1" "$HOME/.config/nvim/$file_name"
}

temp=$(mktemp -d)
pushd $temp > /dev/null || exit 1
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  ./squashfs-root/AppRun --version

  # Optional: exposing nvim globally
  sudo rsync -avu squashfs-root/ /squashfs-root
  sudo ln -sf /squashfs-root/AppRun /usr/bin/nvim
popd > /dev/null || exit 1

rm -rf $temp
python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim
gem install neovim
npm install -g neovim

create_nvim_link "$current_dir/init.vim"
create_nvim_link "$current_dir/coc-settings.json"
create_vim_link "$current_dir/nvimrc.bundles"

set +e
nvim --noplugin +"silent PlugInstall" +qall
set -e
