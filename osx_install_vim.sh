#!/bin/bash

mkdir -p ~/.vim/bundle

if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

brew update
brew install vim --with-override-system-vi
brew install reattach-to-user-namespace direnv

defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
