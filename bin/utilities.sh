#!/bin/bash

function find_current_dir() {
  pushd $(dirname $0) > /dev/null
    current_dir=$(pwd)
  popd > /dev/null
  echo $current_dir
}

function find_dir() {
  pushd $1 > /dev/null
    dir=$(pwd)
  popd > /dev/null
  echo $dir
}

bin_dir=$(find_current_dir $@)
export dotfiles_dir=$(find_dir $bin_dir/..)

export darwin=false
export ubuntu=false
export unsupported=false

function operating_system_unsupported() {
  echo "Operating syetem ${linux_flavor} is currently unsupported"
  exit 1
}

case $OSTYPE in
  darwin*)
    export darwin=true
    export CONFIG_FILE=bash_profile
    ;;
  *)
    export linux_flavor=`gawk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"'`
    export CONFIG_FILE=bashrc
    case $linux_flavor in
      Ubuntu)
        export ubuntu=true
        ;;
      *)
        export unsupported=true
        ;;
    esac
    ;;
esac