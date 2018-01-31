#!/bin/bash

set -ex

function find_current_dir() {
  pushd $(dirname $0) > /dev/null
    current_dir=$(pwd)
  popd > /dev/null
  echo $current_dir
}
current_dir=$(find_current_dir $@)
vimfiles_dir=$(cd $current_dir/../vendor/luan/vimfiles && pwd)

source $current_dir/utilities.sh

function full_installation() {
    if $ubuntu; then
     if [ -z "$DOTFILES_USER" ]; then
        echo "Please specify the DOTFILES_USER env var for whom you are installing dotfiles for"
        exit 1
     fi
    fi

    $current_dir/install_dependencies.sh
    $current_dir/install_dotfiles.sh
    $current_dir/install_powerline_fonts.sh
    $current_dir/os_specific.sh
    $current_dir/install_neovim.sh
    $current_dir/install_python.sh
    $current_dir/install_javascript.sh
#    $current_dir/install_ruby.sh
    $vimfiles_dir/bin/install

    # Run Tests
    [ "$2" != '--skip-tests' ] && $current_dir/shpec
}

function minimal_installation() {
    if $darwin; then
        brew install git the_silver_searcher
    elif $ubuntu; then
        sudo apt-get update && sudo apt-get install -y git silversearcher-ag
    else
        operating_system_unsupported
    fi

    $current_dir/install_dotfiles.sh
    $vimfiles_dir/bin/install
}

function incorrect_usage() {
    echo "Incorrect usage: please provide an installation type of full or minimal"
    exit 1
}

if [ $# -lt 1 ]; then
    incorrect_usage
fi

pushd $current_dir/..
  git submodule update --recursive
popd

if [ "$1" == "full" ]; then
    full_installation
elif [ "$1" == "minimal" ]; then
    minimal_installation
else
    incorrect_usage
fi

exit 0
