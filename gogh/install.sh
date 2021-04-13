#!/usr/bin/env zsh
current_dir="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME/.local/src"
pushd "$HOME/.local/src" || exit 1
  if [[ ! -e gogh ]]; then
    git clone https://github.com/Mayccoll/Gogh.git gogh
  fi

  pushd gogh/themes || exit 1
    # necessary on ubuntu
    export TERMINAL=gnome-terminal
    ln -sf $current_dir/gruvbox-hard.sh

    # install themes
    ./solarized-light.sh
    ./gruvbox-hard.sh
    ./tomorrow.sh
  popd || exit 1
popd || exit 1
