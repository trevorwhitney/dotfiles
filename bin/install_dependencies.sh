#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

if $darwin; then
  brew update
  brew install vim --with-override-system-vi --without-python --with-python3
  brew install reattach-to-user-namespace \
    direnv \
    gettext \
    the_silver_searcher \
    uncrustify \
    gradle \
    gawk \
    git

  brew link --force gettext
elif $ubuntu; then
  sudo apt-get install -y \
    software-properties-common \
    python-software-properties

  sudo add-apt-repository -y ppa:jonathonf/vim
  sudo apt-get update

  sudo apt-get install -y \
    vim \
    gettext \
    silversearcher-ag \
    uncrustify \
    gradle \
    curl \
    git

  curl -OLk https://github.com/direnv/direnv/releases/download/v2.10.0/direnv.linux-amd64
  sudo mv direnv.linux-amd64 /usr/local/bin/direnv
  sudo chmod a+x /usr/local/bin/direnv
else
  operating_system_unsupported
fi
