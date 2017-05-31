#!/bin/bash

shpec_dir=$(cd $(dirname $0) && pwd)
root_dir=$(cd $shpec_dir/.. && pwd)

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

describe "dotfile"
  describe "configuration"
    for file in ctags dircolors vimrc ideavimrc gitignore_global git_template; do
      it "links the $file configuration"
        assert symlink $HOME/.$(basename $file) $root_dir/$file
      end
    done

    for file in git-completion gradle-completion; do
      it "links the $file bash completion"
        assert symlink $HOME/bash_completion.d/$(basename $file) $root_dir/bash_completion/$file
      end
    done

    it "links the corrent tmux configuration"
      if $darwin; then
        assert symlink $HOME/.tmux.conf $root_dir/tmux.darwin.conf
      else
        assert symlink $HOME/.tmux.conf $root_dir/tmux.linux.conf
      fi
    end

    it "links the correct bash profile"
      if $darwin; then
        assert symlink $HOME/.bash_profile $root_dir/bash_profile
      else
        assert symlink $HOME/.bashrc $root_dir/bashrc
      fi
    end

    it "installs bash_it"
      assert file_present $HOME/.bash_it
    end
  end
end
