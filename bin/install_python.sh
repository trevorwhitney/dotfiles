#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

if [ ! `which pyenv` ]; then
  if $darwin; then
     brew install pyenv pyenv-virtualenv
    source ~/.bash_profile
  elif $ubuntu; then
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
    source $HOME/$CONFIG_FILE
    pyenv update
    git clone https://github.com/yyuu/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
    source ~/.bashrc
  else
    operating_system_unsupported
  fi
fi

if [ ! `pyenv versions | grep 2.7.11` ]; then
  pyenv install 2.7.11
  pyenv virtualenv 2.7.11 neovim2
fi

if [ ! `pyenv versions | grep 3.4.4` ]; then
  pyenv install 3.4.4
  pyenv virtualenv 3.4.4 neovim3
fi
