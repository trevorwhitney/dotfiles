#!/usr/bin/env bash

mkdir -p "$HOME/.local/src"
pushd "$HOME/.local/src" || exit 1
  if [[ ! -e gogh ]]; then
    git clone https://github.com/Mayccoll/Gogh.git gogh
  fi

  pushd gogh/themes || exit 1
    # necessary on ubuntu
    export TERMINAL=gnome-terminal

    # install themes
    ./solarized-light.sh
    ./gruvbox.sh
    ./tomorrow.sh
  popd || exit 1
popd || exit 1
