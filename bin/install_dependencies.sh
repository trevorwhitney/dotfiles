#!/bin/bash

set -ex

current_dir=$(cd $(dirname $0) && pwd)
source $current_dir/utilities.sh

if $darwin; then
  set +e

  brew update
  [ ! `which vim` ] && brew install vim --with-override-system-vi --without-python --with-python3
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

  curl -OLk https://github.com/direnv/direnv/releases/download/v2.10.0/direnv.linux-amd64
  sudo mv direnv.linux-amd64 /usr/local/bin/direnv
  sudo chmod a+x /usr/local/bin/direnv

  mkdir -p ~/tmp/astyle
  curl -L https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_linux.tar.gz/download -o ~/tmp/astyle/astyle.tar.gz
  pushd ~/tmp/astyle
    tar -xzf astyle.tar.gz
    pushd astyle/build/mac
      make
      cp bin/AStyle /usr/local/bin/astyle
      chmod a+x /usr/local/bin/astyle
    popd
  popd
  rm -rf ~/tmp/astyle
else
  operating_system_unsupported
fi
