#!/usr/bin/env zsh

source "$HOME/.zshrc"

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
if [[ `command -v python3` ]]; then
  python3 -m pip install --user --upgrade pynvim
fi

# make sure pip is installed for python since it's no longer in
# ubuntu package manager
if [[ `command -v python` ]]; then
  # The following installs pip, this should be moved into a python recipe
  # temp="$(mktemp -d)"
  # pushd $temp > /dev/null || exit 1
  #   curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
  #   python get-pip.py
  # popd > /dev/null || exit 1
  # rm -rf $temp

  python -m pip install --user --upgrade pynvim
fi

if [[ `command -v python2` ]]; then
  # The following installs pip, this should be moved into a python recipe
  # temp="$(mktemp -d)"
  # pushd $temp > /dev/null || exit 1
  #   curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
  #   python2 get-pip.py
  # popd > /dev/null || exit 1
  # rm -rf $temp

  python2 -m pip install --user --upgrade pynvim
fi

gem install neovim
sudo npm install -g neovim

mkdir -p "$HOME/.config/nvim"

create_nvim_link "$current_dir/init.vim"
create_nvim_link "$current_dir/coc-settings.json"
create_vim_link "$current_dir/nvimrc.bundles.vim"

set +e
nvim --noplugin +"silent PlugInstall" +qall
set -e

sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
