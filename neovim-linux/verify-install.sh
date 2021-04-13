#!/usr/bin/env zsh

comand -v nvim > /dev/null
nvim --version > /dev/null

test -e $HOME/.vim/nvimrc.bundles.vim
