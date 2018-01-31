#!/bin/bash

set -ex

function find_current_dir() {
  pushd $(dirname $0) > /dev/null
    current_dir=$(pwd)
  popd > /dev/null
  echo $current_dir
}
current_dir=$(find_current_dir $@)

source $current_dir/utilities.sh

if [ ! `which pyenv` ]; then
  if $darwin; then
     brew install pyenv pyenv-virtualenv
  elif $ubuntu; then
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
    export PYENV_ROOT=$HOME/.pyenv
    export PATH=$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init -)"
    pyenv update
    eval "$(pyenv virtualenv-init -)"
  else
    operating_system_unsupported
  fi
fi

if [ ! -e $HOME/.pyenv/versions/3.4.4 ]; then
  pyenv install 3.4.4
  pyenv virtualenv 3.4.4 neovim3
  pyenv activate neovim3
  pip install neovim
fi
