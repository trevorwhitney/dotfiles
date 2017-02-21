#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
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

if [ ! -e $HOME/.pyenv/versions/2.7.11 ]; then
  pyenv install 2.7.11
  pyenv virtualenv 2.7.11 neovim2
  pyenv activate neovim2
  pip install neovim
fi

if [ ! -e $HOME/.pyenv/versions/3.4.4 ]; then
  pyenv install 3.4.4
  pyenv virtualenv 3.4.4 neovim3
  pyenv activate neovim3
  pip install neovim
fi
