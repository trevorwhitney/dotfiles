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
  curl -LkO "https://github.com/barnumbirr/alacritty-debian/releases/download/v${version}/alacritty_${version}_amd64_debian_unstable.deb"
  sudo dpkg -i "alacritty_${version}_amd64_debian_unstable.deb"
  popd > /dev/null || exit 1
  rm -rf "$tmp"
}

if [[ $(uname) = "Darwin" ]]; then
  brew install alacritty || true
else
  sudo apt-get install -y alacritty || install_from_package
fi

mkdir -p $HOME/.config/alacritty

create_alacritty_link "$current_dir/alacritty-light.yml"
create_alacritty_link "$current_dir/alacritty-dark.yml"
create_alacritty_link "$current_dir/alacritty-popos.yml"
create_alacritty_link "$current_dir/base.yml"
create_alacritty_link "$current_dir/gruvbox-dark.yml"
create_alacritty_link "$current_dir/gruvbox.yml"
create_alacritty_link "$current_dir/solarized-dark.yml"
create_alacritty_link "$current_dir/solarized.yml"
create_alacritty_link "$current_dir/remote-dark.yml"
create_alacritty_link "$current_dir/remote.yml"
create_alacritty_link "$current_dir/open-in-vim.yml"

sudo ln -s "$current_dir/open-in-vim" /usr/local/bin/open-in-vim

create_xdg_data_link applications "$current_dir/open-in-vim.desktop"
create_xdg_data_link applications "$current_dir/defaults.list"
