#!/usr/bin/env zsh
brewfile_directory=$(cd "$(dirname $0)" && pwd)

brew tap homebrew/bundle

cd "$brewfile_directory" && brew bundle check
