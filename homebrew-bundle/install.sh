#!/usr/bin/env zsh
brewfile_directory=$(cd "$(dirname $0)" && pwd)

brew tap homebrew/bundle
brew upgrade
