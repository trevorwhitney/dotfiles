#!/bin/bash

mkdir ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
brew update
brew install vim
brew install reattach-to-user-namespace
