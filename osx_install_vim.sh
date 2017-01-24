#!/bin/bash

mkdir -p ~/.vim/bundle

if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Intalls powerline fonts
mkdir -p ~/tmp
pushd ~/tmp
  git clone https://github.com/powerline/fonts.git
  cd fonts
  ./install.sh
popd
rm -rf ~/tmp/fonts

brew update
brew install vim --with-override-system-vi
brew install reattach-to-user-namespace direnv gettext the_silver_searcher
brew link --force gettext

defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write com.apple.finder AppleShowAllFiles YES
