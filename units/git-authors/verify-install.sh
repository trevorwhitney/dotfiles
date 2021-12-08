#!/usr/bin/env zsh

current_dir="$(cd $(dirname $0); pwd)"
cmp $HOME/.git-authors $current_dir/git-authors > /dev/null 2> /dev/null
