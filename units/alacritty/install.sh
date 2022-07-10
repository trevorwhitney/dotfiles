#!/usr/bin/env zsh

current_dir="$(cd $(dirname "$0") && pwd)"
dot_files_dir="$(cd $current_dir/../.. && pwd)"

# shellcheck disable=SC1090
source "$dot_files_dir/lib.sh"

function install_from_package() {
  tmp=$(mktemp -d)
  version=$(cat $current_dir/version)

  pushd "$tmp" > /dev/null || exit 1
  echo "$tmp"
  curl -LkO "https://github.com/barnumbirr/alacritty-debian/releases/download/v${version}/alacritty_${version}_amd64_unstable.deb"
  sudo dpkg -i "alacritty_${version}_amd64_unstable.deb"
  popd > /dev/null || exit 1
  rm -rf "$tmp"
}

install_from_package

mkdir -p $HOME/.config/alacritty

create_alacritty_link "$current_dir/open-in-vim.yml"

sudo ln -sf "$current_dir/open-in-vim" /usr/local/bin/open-in-vim

create_xdg_data_link applications "$current_dir/open-in-vim.desktop"
create_xdg_data_link applications "$current_dir/defaults.list"
