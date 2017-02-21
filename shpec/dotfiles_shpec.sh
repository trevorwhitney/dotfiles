#!/bin/bash

shpec_dir=$(cd $(dirname $0) && pwd)
source $shpec_dir/../bin/utilities.sh

root_dir=$(cd $shpec_dir/.. && pwd)

describe "dotfile"
  describe "configuration"
    for file in .ctags .dircolors .vimrc .ideavimrc .gitignore_global .git-completion; do
      it "links the $file configuration"
        assert symlink $HOME/$(basename $file) $root_dir/$file
      end
    done

    it "links the corrent tmux configuration"
      if $darwin; then
        assert symlink $HOME/.tmux.conf $root_dir/.tmux.darwin.conf
      else
        assert symlink $HOME/.tmux.conf $root_dir/.tmux.linux.conf
      fi
    end

    it "links the correct bash profile"
      if $darwin; then
        assert symlink $HOME/.bash_profile $root_dir/.bash_profile
      else
        assert symlink $HOME/.bashrc $root_dir/.bashrc
      fi
    end

    it "installs bash_it"
      assert file_present $HOME/.bash_it
    end
  end
end
