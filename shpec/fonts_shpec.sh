#!/bin/bash
export darwin=false
export ubuntu=false
export unsupported=false

case $OSTYPE in
  darwin*)
    export darwin=true
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

describe "fonts"
  it "installs powerline fonts"
    if $darwin; then
      assert file_present $HOME/Library/Fonts
    else
      asser file_present $HOME/.local/share/fonts
    fi
  end
end
