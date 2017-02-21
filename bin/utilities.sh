#!/bin/bash

bin_dir=$(cd $(dirname $0) && pwd)
export dotfiles_dir=$(cd $bin_dir/.. && pwd)

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
    export CONFIG_FILE=.bash_profile
    ;;
  *)
    export linux_flavor=`gawk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"'`
    export CONFIG_FILE=.bashrc
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

