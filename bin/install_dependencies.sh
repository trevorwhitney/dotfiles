#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

if $darwin; then
  set +e

  brew update
  if [ ! `which vim` ]; then brew install vim --with-override-system-vi --without-python --with-python3; fi
  brew install reattach-to-user-namespace \
    direnv \
    gettext \
    the_silver_searcher \
    uncrustify \
    gradle \
    gawk \
    git

  brew link --force gettext
  set -e

  function install_astyle() {
    mkdir -p ~/tmp/astyle
    curl -L https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_macos.tar.gz/download -o ~/tmp/astyle/astyle.tar.gz
    pushd ~/tmp/astyle
      tar -xzf astyle.tar.gz
      pushd astyle/build/mac
        make
        cp bin/AStyle /usr/local/bin/astyle
        chmod a+x /usr/local/bin/astyle
      popd
    popd
    rm -rf ~/tmp/astyle
  }
  if [ ! `which astyle` ]; then install_astyle; fi

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
    curl \
    git \
    build-essential \
    zlibc \
    zlib1g-dev \
    libyaml-dev \
    openssl \
    libxslt-dev \
    libxml2-dev \
    libssl-dev \
    libreadline6 \
    libreadline6-dev

  function install_direnv() {
    sudo curl -Lk https://github.com/direnv/direnv/releases/download/v2.10.0/direnv.linux-amd64 \
      -o /usr/local/bin/direnv
    sudo chmod a+x /usr/local/bin/direnv
  }
  if [ ! `which direnv` ]; then install_direnv; fi

  function install_astyle() {
    mkdir -p $HOME/tmp/astyle
    curl -L https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_linux.tar.gz/download -o ~/tmp/astyle/astyle.tar.gz
    pushd $HOME/tmp/astyle
      tar -xzf astyle.tar.gz
      pushd astyle/build/gcc
        make
        sudo cp bin/astyle /usr/local/bin/astyle
        sudo chmod a+x /usr/local/bin/astyle
      popd
    popd
    rm -rf ~/tmp/astyle
  }
  if [ ! `which astyle` ]; then install_astyle; fi
else
  operating_system_unsupported
fi
