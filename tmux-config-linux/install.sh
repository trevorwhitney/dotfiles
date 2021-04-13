#!/usr/bin/env zsh

current_dir=$(cd "$(dirname "$0")" && pwd)
dot_files_dir=$(cd "$current_dir/.." && pwd)

source "$dot_files_dir/lib.sh"

pushd "$HOME" > /dev/null || exit 1
  if [[ -e .tmux ]]; then
    echo '.tmux already cloned, looking for updates'
    pushd .tmux >> /dev/null || exit 1
      git pull --rebase
    popd > /dev/null || exit 1
  else
    echo 'cloning .tmux'
    git clone https://github.com/gpakosz/.tmux.git
  fi

  ln -s -f .tmux/.tmux.conf
popd > /dev/null || exit 1

create_link "$current_dir/tmux.conf.local"
