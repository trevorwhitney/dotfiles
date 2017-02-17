#!/bin/bash

shpec_dir=$(cd $(dirname $0) && pwd)
source $shpec_dir/../bin/utilities.sh

#TODO: remove dependecy on ruby
ruby_command="File.expand_path('..', '$shpec_dir')"
root_dir=$(ruby -e "puts $ruby_command")

describe "dotfile"
  describe "configuration"
    for file in .ctags .dircolors .tmux.conf .vimrc .ideavimrc .gitignore_global .git-completion; do
      it "links the $file configuration"
      assert symlink $HOME/$(basename $file) $root_dir/$file
      end
    done

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

