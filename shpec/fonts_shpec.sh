#!/bin/bash
shpec_dir=$(cd $(dirname $0) && pwd)
source $shpec_dir/../bin/utilities.sh

describe "fonts"
  it "installs powerline fonts"
    if $darwin; then
      assert file_present $HOME/Library/Fonts
    else
      asser file_present $HOME/.local/share/fonts
    fi
  end
end
