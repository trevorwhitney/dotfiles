#!/usr/bin/env bash

comand -v nvim > /dev/null
nvim --version > /dev/null

test -e $HOME/.vim/nvimrc.bundles
