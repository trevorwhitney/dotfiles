#!/bin/bash
shpec_dir=$(cd $(dirname $0) && pwd)
root_dir=$(cd $shpec_dir/.. && pwd)
vim_dir=$root_dir/.vim

describe "vim binaries and configuration"
  describe "binaries"
    it "installs the vim binary"
      assert present $(which vim)
    end

    it "installs the neovim binary"
      assert present $(which nvim)
    end
  end

  describe "configuration"
    it "links the style directory"
      assert symlink $HOME/.vim/style $root_dir/style
    end

    it "links the neovim configuration"
      assert symlink $XDG_CONFIG_HOME/nvim $HOME/.vim
    end

    it "installs dein to $HOME/.vim/bundles"
      assert file_present $HOME/.vim/bundles
    end

    for file in `ls $vim_dir | grep vimrc`; do
      it "symlinks all the vim configuration for $file"
          assert symlink $HOME/.vim/$(basename $file) $vim_dir/$file
      end
    done
  end
end
